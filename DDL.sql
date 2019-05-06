	-- Database: final

	-- DROP DATABASE final;

	-- Um script (arquivo textual .sql) com os comandos DDL para a criação de todos os objetos no banco de dados PostgreSQL, incluindo views, funções e gatilhos

	CREATE TABLE IF NOT EXISTS oficinas (
		cnpj VARCHAR(20) PRIMARY KEY,
		nome VARCHAR(255) NOT NULL,
		email VARCHAR(255),
		tel VARCHAR(20) NOT NULL,
		cep VARCHAR(10),
		uf CHAR(2),
		cidade VARCHAR(255),
		bairro VARCHAR(255),
		rua VARCHAR(255),
		numero VARCHAR(255),
		lat VARCHAR(55),
		long VARCHAR(55)
	);


	CREATE TABLE IF NOT EXISTS usuario (
		cpf varchar(11) PRIMARY KEY,
		nome VARCHAR(255) NOT NULL,
		email VARCHAR(255) NOT NULL,
		senha VARCHAR(255) NOT NULL,
		senha_confirmacao VARCHAR(255) NOT NULL,
		tel VARCHAR(20) NOT NULL,
		cep VARCHAR(10),
		uf CHAR(2),
		cidade VARCHAR(255),
		bairro VARCHAR(255),
		rua VARCHAR(255),
		numero VARCHAR(255)
	);


	CREATE TABLE IF NOT EXISTS marcas (
		id SERIAL PRIMARY KEY,
		nome VARCHAR(255) NOT NULL,
		pais VARCHAR(255)
	);

	CREATE TABLE IF NOT EXISTS modelos (
		id SERIAL PRIMARY KEY,
		nome VARCHAR(255) NOT NULL,
		id_marca INTEGER  REFERENCES marcas(id) NOT NULL
	);


	CREATE TABLE IF NOT EXISTS veiculos (
		placa VARCHAR(8) PRIMARY KEY,
		cpf_usuario VARCHAR(11)  REFERENCES usuario(cpf) NOT NULL,
		id_modelos INTEGER  REFERENCES modelos(id) NOT NULL,
		cor VARCHAR(255),
		ano VARCHAR(4),
		km INTEGER
	);

	CREATE TABLE IF NOT EXISTS categorias (
		id SERIAL PRIMARY KEY,
		nome VARCHAR(255) NOT NULL
	);

	CREATE TABLE IF NOT EXISTS servicos (
		id SERIAL PRIMARY KEY,
		id_categorias INTEGER  REFERENCES categorias(id),
		nome VARCHAR(255) NOT NULL
	);

	CREATE TABLE IF NOT EXISTS situacoes (
		id SERIAL PRIMARY KEY,
		nome VARCHAR(255) NOT NULL
	);


	CREATE TABLE IF NOT EXISTS atendimentos (
		id SERIAL PRIMARY KEY,
		data_abertura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
		cpf_usuario VARCHAR(11)  REFERENCES usuario(cpf) NOT NULL,
		placa_veiculo VARCHAR(8)  REFERENCES veiculos(placa) NOT NULL,
		data_agendamento DATE,
		tempo_previsto VARCHAR(255),

		-- CHECK 1
		data_fechamento DATE CHECK (data_fechamento > data_agendamento),
		
		valor INTEGER,
		id_situacao INTEGER CHECK (id_situacao <= 10) REFERENCES situacoes(id) DEFAULT 1,
		observacoes TEXT
	);


	--RELACIONAMENTO COM ATRIBUTOS
	CREATE TABLE IF NOT EXISTS avaliacao_oficina (
		cnpj_oficina VARCHAR(20)  REFERENCES oficinas(cnpj) NOT NULL,
		id_atendimento INTEGER  REFERENCES atendimentos(id) NOT NULL,

		-- CHECK 2
		nota INTEGER NOT NULL CHECK (nota <= 10),

		comentarios TEXT,
		PRIMARY KEY(id_atendimento, cnpj_oficina)
	);

	CREATE TABLE IF NOT EXISTS avaliacao_atendimento (
		id_atendimento INTEGER  REFERENCES atendimentos(id) NOT NULL,

		-- CHECK 3
		nota INTEGER NOT NULL CHECK (nota <= 10),

		comentarios TEXT,

		PRIMARY KEY(id_atendimento)
	);

	-- RELACOES N X M
	CREATE TABLE IF NOT EXISTS atendimentos_oficinas_servicos (
		id_atendimento INTEGER  REFERENCES atendimentos(id) NOT NULL,
		id_servico INTEGER REFERENCES servicos(id) NOT NULL,
		cnpj_oficina VARCHAR(20)  REFERENCES oficinas(cnpj) NOT NULL,
		PRIMARY KEY(id_atendimento, id_servico, cnpj_oficina)
	);


	CREATE TABLE IF NOT EXISTS oficinas_servicos (
		cnpj_oficina VARCHAR(20) REFERENCES oficinas(cnpj) NOT NULL,
		id_servico INTEGER REFERENCES servicos(id) NOT NULL,
		preco INTEGER,
		PRIMARY KEY(cnpj_oficina, id_servico)
	);

-- TRIGGERS
	CREATE FUNCTION verifica_placa() RETURNS trigger AS $verifica_placa$
	BEGIN
	IF EXISTS(SELECT * from veiculos where placa = NEW.placa) THEN
	RAISE EXCEPTION 'Placa de veículo já cadastrada';
	END IF;
	RETURN NEW;
	END;
	$verifica_placa$ LANGUAGE plpgsql;

	CREATE TRIGGER verifica_placa BEFORE INSERT OR UPDATE 
	ON veiculos
	FOR EACH ROW EXECUTE 
	PROCEDURE verifica_placa();

	CREATE FUNCTION verifica_atendimento() RETURNS trigger AS $verifica_atendimento$
	BEGIN
	IF EXISTS(SELECT * from atendimentos 
		LEFT JOIN avaliacao_atendimento 
		ON(atendimentos.id = avaliacao_atendimento.id_atendimento) 
		where atendimentos.cpf_usuario = NEW.cpf_usuario AND avaliacao_atendimento.id_atendimento IS NULL AND atendimentos.id_situacao = 8)
	THEN
		RAISE EXCEPTION 'Realize a avaliacao de seus atendimentos';
	END IF;
	RETURN NEW;
	END;
	$verifica_atendimento$ LANGUAGE plpgsql;

	CREATE TRIGGER verifica_atendimento BEFORE INSERT OR UPDATE 
	ON atendimentos
	FOR EACH ROW EXECUTE 
	PROCEDURE verifica_atendimento();

	CREATE FUNCTION verifica_senha() RETURNS trigger AS $verifica_senha$
	BEGIN
	IF NEW.senha <> NEW.senha_confirmacao THEN
		RAISE EXCEPTION 'Senhas não conferem.';
	END IF;
	RETURN NEW;
	END;
	$verifica_senha$ LANGUAGE plpgsql;

	CREATE TRIGGER verifica_senha BEFORE INSERT OR UPDATE 
	ON usuario
	FOR EACH ROW EXECUTE 
	PROCEDURE verifica_senha();

-- PROCEDURE
	CREATE OR REPLACE FUNCTION InsereAtendimento(id_servico INTEGER, cnpj_oficina VARCHAR(20), cpf_usuario VARCHAR(20), placa_veiculo VARCHAR(8))
	      RETURNS VOID AS $InsereAtendimento$
	      DECLARE x INTEGER;
	      BEGIN
	      	INSERT INTO atendimentos (cpf_usuario, placa_veiculo) VALUES (cpf_usuario, placa_veiculo);

			x :=(SELECT id FROM atendimentos ORDER BY id DESC LIMIT 1);
	        INSERT INTO atendimentos_oficinas_servicos VALUES (x, id_servico, cnpj_oficina);
	      END;$InsereAtendimento$
	  	LANGUAGE 'plpgsql';

-- VIEW 01
CREATE VIEW servicosPorValor AS 
	SELECT servicos.nome, oficinas_servicos.preco FROM oficinas
		INNER JOIN oficinas_servicos ON (cnpj = cnpj_oficina)
		INNER JOIN servicos ON (id_servico = servicos.id)
	WHERE oficinas.nome = 'Oficina 01'
	ORDER BY oficinas_servicos.preco ASC;

-- VIEW 02
CREATE VIEW servicosPorAtendimentos AS
	SELECT servicos.nome FROM atendimentos
		INNER JOIN atendimentos_oficinas_servicos ON (atendimentos.id = atendimentos_oficinas_servicos.id_atendimento)
		INNER JOIN servicos ON(atendimentos_oficinas_servicos.id_servico = servicos.id)
	WHERE atendimentos.id = 1;