-- Um script (arquivo textual .sql) com os comandos DML e as invocações de funções que populam o seu banco de dados.
-- A quantidade de dados deve ser sulficiente para exemplificar as consultas de seu projeto e regras contidas nas funções e gatilhos de seu projeto;

-- POPULAR BANCO --

INSERT INTO oficinas (cnpj, nome, email, tel) VALUES 
('1111', 'Oficina 01', 'oficina01@gmail.com', '8411111111'), 
('2222', 'Oficina 02', 'oficina02@gmail.com', '8422222222');

INSERT INTO usuario (cpf, nome, email, senha, senha_confirmacao, tel) VALUES 
('11111111111', 'Joao', 'jv@gmail.com', '123456', '123456', '8411111111'), 
('22222222222', 'Matheus', 'matheus@gmail.com', '123456', '123456', '8422222222');

INSERT INTO marcas (nome, pais) VALUES 
('Citroen', 'França'), 
('Peugeot', 'França'), 
('Volkswagen', 'Alemanha'), 
('Fiat', 'Italia');

INSERT INTO modelos (nome, id_marca) VALUES 
('C3', 1), 
('208', 2), 
('Gol', 3), 
('Palio', 4);

INSERT INTO veiculos (placa, cpf_usuario, id_modelos, cor, ano, km) VALUES 
('AAA1111', '11111111111', 1, 'Azul', '2006', 1000), 
('BBB2222', '11111111111', 2, 'Branco', '2010', 2000), 
('CCC3333', '22222222222', 3, 'Preto', '2017', 3000), 
('DDDD4444', '22222222222', 4, 'Prata', '2012', 1200);

INSERT INTO categorias (nome) VALUES 
('Categoria 1'), 
('Categoria 2'), 
('Categoria 3'), 
('Categoria 4');

INSERT INTO servicos (id_categorias, nome) VALUES 
(1, 'Refrigeração'), 
(1, 'Limpeza de Filtro'), 
(2, 'Pneus'), 
(2, 'Rodas'), 
(3, 'Alinhamento'),
(3, 'Balanceamento'), 
(4, 'Motor'), 
(4, 'Revisão');

INSERT INTO situacoes (nome) VALUES
('Abertura de chamado'),
('Aguardando'),
('Em atendimento'),
('Agendado'),
('Agendamento confirmado'),
('Em execução'),
('Finalizado'),
('Encerrado');

INSERT INTO atendimentos (cpf_usuario, placa_veiculo) VALUES
('11111111111', 'AAA1111'),
('11111111111', 'BBB2222'),
('11111111111', 'CCC3333'),
('11111111111', 'DDDD4444');

INSERT INTO avaliacao_atendimento (id_atendimento, nota, comentarios) VALUES
(1, 10, 'Servico excelente1'),
(3, 10, 'Servico excelente2');

INSERT INTO avaliacao_oficina (cnpj_oficina, nota, comentarios, id_atendimento) VALUES
('1111', 10, 'Otima oficina', 1),
('2222', 1, 'Pessima oficina', 3);

INSERT INTO atendimentos_oficinas_servicos(id_atendimento, id_servico, cnpj_oficina) VALUES 
(1, 1, '1111'),
(1, 2, '1111'),
(2, 3, '2222'),
(2, 4, '2222');

INSERT INTO oficinas_servicos(cnpj_oficina, id_servico, preco) VALUES 
('1111', 1, 1000),
('1111', 2, 100),
('2222', 3, 10),
('2222', 4, 15);

-- FIM POPULAR BANCO

-- TESTE TRIGGER 1
INSERT INTO atendimentos (cpf_usuario, placa_veiculo) VALUES ('22222222222', 'CCC3333');

SELECT * FROM atendimentos;

	-- ALTERAR PARA ID CORRESPONDENTE
UPDATE atendimentos SET id_situacao = 8 WHERE atendimentos.id = 5;

INSERT INTO atendimentos (cpf_usuario, placa_veiculo) VALUES ('22222222222', 'DDDD4444');

	-- ALTERAR PARA ID CORRESPONDENTE
INSERT INTO avaliacao_atendimento (id_atendimento, nota, comentarios) VALUES (5, 10, 'Servico excelente2');

INSERT INTO atendimentos (cpf_usuario, placa_veiculo) VALUES ('22222222222', 'DDDD4444');
-- FIM TRIGGER 1

-- TESTE TRIGGER 2
INSERT INTO usuario (cpf, nome, email, senha, senha_confirmacao, tel) VALUES 
('33333333333', 'Jose', 'jose@gmail.com', '123456', '123455', '8411111111');
-- FIM TRIGGER 2

-- TESTE PROCEDURE
SELECT InsereAtendimento(1, '1111', '11111111111', 'AAA1111');

SELECT * FROM atendimentos;
SELECT * FROM atendimentos_oficinas_servicos;
-- FIM PROCEDURE