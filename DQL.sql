-- Um script (arquivo textual .sql) com os comandos DQL que representam os relatórios do seu projeto;

SELECT servicos.nome FROM atendimentos
	INNER JOIN atendimentos_oficinas_servicos ON (atendimentos.id = atendimentos_oficinas_servicos.id_atendimento)
	INNER JOIN servicos ON(atendimentos_oficinas_servicos.id_servico = servicos.id)
WHERE atendimentos.id = 1;

SELECT oficinas.nome FROM oficinas
	INNER JOIN oficinas_servicos ON (cnpj = cnpj_oficina)
	INNER JOIN servicos ON (oficinas_servicos.id_servico = servicos.id)
	INNER JOIN categorias ON (categorias.id = servicos.id_categorias)
WHERE categorias.nome = 'Categoria 1';

SELECT servicos.nome, oficinas_servicos.preco FROM oficinas
	INNER JOIN oficinas_servicos ON (cnpj = cnpj_oficina)
	INNER JOIN servicos ON (id_servico = servicos.id)
WHERE oficinas.nome = 'Oficina 01'
ORDER BY oficinas_servicos.preco ASC;

SELECT * from atendimentos 
        LEFT JOIN avaliacao_atendimento 
        ON(atendimentos.id = avaliacao_atendimento.id_atendimento) 
        where atendimentos.cpf_usuario = '11111111111' AND avaliacao_atendimento.id_atendimento IS NULL AND atendimentos.id_situacao = 8;
