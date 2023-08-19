/*

Recuperações simples com SELECT Statement
Filtros com WHERE Statement
Crie expressões para gerar atributos derivados
Defina ordenações dos dados com ORDER BY
Condições de filtros aos grupos – HAVING Statement
Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados
Diretrizes
Não há um mínimo de queries a serem realizadas;
Os tópicos supracitados devem estar presentes nas queries;
Elabore perguntas que podem ser respondidas pelas consultas;
As cláusulas podem estar presentes em mais de uma query;
O projeto deverá ser adicionado a um repositório do Github para futura avaliação do desafio de projeto. Adicione ao Readme a descrição do projeto lógico para fornecer o contexto sobre seu esquema lógico apresentado.

Objetivo:
[Relembrando] Aplique o mapeamento para o  cenário:

“Refine o modelo apresentado acrescentando os seguintes pontos”

ok - Cliente PJ e PF – Uma conta pode ser PJ ou PF, mas não pode ter as duas informações;
ok - Pagamento – Pode ter cadastrado mais de uma forma de pagamento;
ok - Entrega – Possui status e código de rastreio;
Algumas das perguntas que podes fazer para embasar as queries SQL:

Quantos pedidos foram feitos por cada cliente?
Algum vendedor também é fornecedor?
Relação de produtos fornecedores e estoques;
Relação de nomes dos fornecedores e nomes dos produtos;
Agora é a sua vez de ser o protagonista! Implemente o desafio sugerido pela expert e suba seu projeto para um repositório próprio, com isso, você aumentará ainda mais seu portfólio de projetos no GitHub!
*/

-- ================================= criar banco de dados ecommerce =============================================
create schema ecommerce;
use ecommerce;

-- ================================= criar tabelas dobanco de dados =============================================
-- criar table cliente
create table Cliente(
	idCliente int auto_increment primary key,
    nome varchar(20) not null,
    sobrenome varchar(40),
    tipo enum('CPF', 'CNPJ') not null,
    cpfCnpj char(15) not null,
    endereco varchar(200),
    dataNascimento date not null,
    constraint un_Cliente_cpfCnpj unique(cpfCnpj)
);

-- criar table pedido
create table Pedido(
	idPedido int auto_increment primary key,
    statusPedido ENUM('Em Andamento', 'Enviado', 'Entregue', 'Cancelado') default 'Em Andamento',
    codRastreio char(15) not null,
    descricao varchar(200) not null,
    idCliente int,
    constraint fk_Pedido_Cliente_idCliente foreign key (idCliente) references Cliente(idCliente)
);

-- criar table pagamento
create table Pagamento(
	idPagto int auto_increment primary key,
    formPagto char(20) not null
);

-- criar table produto
create table Produto(
	idProduto int auto_increment primary key,
    descricao varchar(100) not null,
    classificacaoKids bool default false,
    categoria ENUM('Eletrônico', 'Vestuário', 'Brinquedos', 'Alimentos', 'Móveis'),
    avaliacao float default 0,
    dimensao char(10),
    valor float not null,
    constraint un_Produto_descricao unique(descricao)
);

-- criar table vendedor
create table Vendedor(
	idVendedor int auto_increment primary key,
    nome_razaoSocial varchar(100) not null,
    nomeFantasia varchar(100),
    tipo ENUM('CPF', 'CNPJ'),
    cpf_cnpj char(15) not null,
    regiao varchar(50),
    endereco varchar(200) not null,
    contato char(20) not null
);

-- criar table fornecedor
create table Fornecedor(
	idFornecedor int auto_increment primary key,
    razaoSocial varchar(100) not null,
    nomeFantasia varchar(100),
    cnpj char(15) not null,
    contato char(20) not null,
    endereco varchar(200) not null
);

-- criar table estoque
create table Estoque(
	idEstoque int auto_increment primary key,
    localizacao varchar(50) not null
);

-- criar table rel_pedido_pagamento
create table relPedidoPagamento(
	idPagto int,
    idPedido int,
    valor float not null,
    primary key (idPagto, idPedido),
    constraint fk_relPedidoPagamento_idPagto foreign key (idPagto) references Pagamento(idPagto),
    constraint fk_relPedidoPagamento_idPedido foreign key (idPedido) references Pedido(idPedido)
);

-- criar table rel_produto_pedido
create table relProdutoPedido(
	idProduto int,
    idPedido int,
    quantidade int default 1,
    primary key (idProduto, idPedido),
    constraint fk_relProdutoPedido_idProduto foreign key (idProduto) references Produto(idProduto),
    constraint fk_relProdutoPedido_idPedido foreign key (idPedido) references Pedido(idPedido)
);

-- criar table rel_produto_estoque
create table relProdutoEstoque(
	idProduto int,
    idEstoque int,
    quantidade int default 1,
    primary key (idProduto, idEstoque),
    constraint fk_relProdutoEstoque_idProduto foreign key (idProduto) references Produto(idProduto),
    constraint fk_relProdutoEstoque_idEstoque foreign key (idEstoque) references Estoque(idEstoque)
);

-- criar table rel_produto_fornecedor
create table relProdutoFornecedor(
	idProduto int,
    idFornecedor int,
    primary key (idProduto, idFornecedor),
    constraint fk_relProdutoFornecedor_idProduto foreign key (idProduto) references Produto(idProduto),
    constraint fk_relProdutoFornecedor_idFornecedor foreign key (idFornecedor) references Fornecedor(idFornecedor)
);

-- criar table rel_produto_vendedor
create table relProdutoVendedor(
	idProduto int,
    idVendedor int,
    quantidade int default 1,
    primary key (idProduto, idVendedor),
    constraint fk_relProdutoVendedor_idProduto foreign key (idProduto) references Produto(idProduto),
    constraint fk_relProdutoVendedor_idVendedor foreign key (idVendedor) references Vendedor(idVendedor)
);

show schemas;
show tables;

-- =============================================== inserir dados pra teste ==============================================================

insert into Cliente (nome, sobrenome, tipo, cpfCnpj, endereco, dataNascimento)
	values('Maria', 'M. da Silva', 'CPF', '123456789', 'rua silva de prata 29, Carangola - Cidade das flores', '1990-12-01'),
		  ('Mathes', 'O. Pimentel', 'CPF', '123455789', 'rua alameda 289, Centro - Cidade das flores', '1989-11-25'),
          ('Ricardo', 'Silva', 'CPF', '123455788', 'avenida alameda vinha 1009, Centro - Cidade das flores', '1985-05-02'),
          ('Julia', 'S. França', 'CPF', '113455789', 'rua laranjeiras 861, Centro - Cidade das flores', '2005-03-14'),
          ('Roberta', 'G. Assis', 'CPF', '123355789', 'avenida koller 19, Centro - Cidade das flores', '2000-04-10'),
          ('Apple', 'Company', 'CNPJ', '12123123000112', 'rua alameda das flores 28, Centro - Cidade das flores', '1970-10-10');
          
-- opçoes categoria - 'Eletrônico', 'Vestuário', 'Brinquedos', 'Alimentos', 'Móveis'
insert into Produto (descricao, classificacaoKids, categoria, avaliacao, dimensao, valor)
	values('Fone de ouvido', false, 'Eletrônico', '4', null, 35.50),
		  ('Barbie Elsa', true, 'Brinquedos', '3', null, 69.90),
          ('Body Carters', true, 'Vestuário', '5', null, 45.00),
          ('Microfone Vedo - Youtuber', false, 'Eletrônico', '4', null, 150.80),
          ('Sofá retrátil', false, 'Móveis', '3', '230x80x70', 2350.00),
          ('Farinha de arroz', false, 'Alimentos', '2', null, 14.90),
          ('Fire Stick Amazon', false, 'Eletrônico', '3', null, 369.90);
          
insert into Pagamento (formPagto) values
	('pix'), 
	('cartão crédito'),
	('cartão débito'),
	('boleto');

-- statusPedido ENUM('Em Andamento', 'Enviado', 'Entregue', 'Cancelado')
insert into Pedido (statusPedido, codRastreio, descricao, idCliente)
	values('Enviado', 'EC151510', 'compra via aplicativo', 6),
		  ('Entregue', 'EC151254', 'compra via aplicativo', 2),
          ('Em Andamento', 'EC121254', 'compra via web site', 3),
          ('Cancelado', 'EC121289','compra via web site', 4);
          
-- idPagto int, idPedido int, valor
insert into relPedidoPagamento (idPagto, idPedido, valor)
	values(1, 1, 150),
		  (2, 2, 180),
          (3, 3, 50),
          (4, 4, 350);
          
insert into Fornecedor (razaoSocial, nomeFantasia, cnpj, contato, endereco)
	values('Almeida e filhos', 'Estrela Brinquedos', '12345678000123', '21-996256565', 'rua 1, 23 - jd. panorama'),
		  ('Joao Alberto', 'Joao Moveis', '12345678000156', '31-996235421', 'rua 12, 54 - jd. uai'),
          ('zezinho', 'Zezinho Alimentos', '12345678000199', '11-996251234', 'rua 2, 29 - jd. estrela');
          
insert into relProdutoFornecedor (idProduto, idFornecedor)
	values(1,1),
		  (5,2),
          (2,3),
          (3,3),
          (7,1);
          
insert into Vendedor (nome_razaoSocial, nomeFantasia, tipo, cpf_cnpj, regiao, endereco, contato)
	values('Tech eletronics', 'Tech eletronics', 'CNPJ', '11222333000123', 'são paulo', 'rua 1, 23 - campinas', '19-996542323'),
		  ('Boutique Durgas', 'Boutique Durgas', 'CNPJ', '11222333000189', 'interior sp', 'rua 23, 23 - rio preto', '17-996543033'),
          ('Kids World', null, 'CNPJ', '11222333000154', 'rio de janeiro', 'rua 15, 18 - volta redonda', '21-996541112');
          
insert into relProdutoVendedor (idProduto, idVendedor, quantidade)
	values(6,1,80),
		  (7,2,10);
          
insert into Estoque (localizacao) values 
	('Rio de janeiro'),
    ('São Paulo'),
    ('Minas Gerais'),
    ('Santa Catarina');

insert into relProdutoEstoque (idProduto, idEstoque, quantidade) values
	(1, 1, 10),
    (2, 2, 100),
    (3, 3, 500),
    (4, 4, 350),
    (5, 4, 15),
    (6, 3, 64),
    (7, 2, 5);
    
insert into relProdutoPedido (idProduto, idPedido, quantidade) values
	(1, 1, 2),
    (2, 2, 1),
    (3, 3, 3),
    (4, 4, 1),
    (5, 4, 2),
    (6, 3, 1),
    (7, 2, 5);
    
-- ================================================================ Query ==============================================================

-- Quantos clientes a empresa tem?
select count(*) from Cliente;

-- Pedidos feitos por cliente?
select 
	idPedido,
    statusPedido,
    codRastreio,
    descricao,
    concat(nome, ' ', sobrenome) as 'Cliente'
from Pedido
inner join Cliente on Pedido.idCliente = Cliente.idCliente;

-- Mostrar os pedido do cliente Ricardo Silva?
select 
	idPedido,
    statusPedido,
    codRastreio,
    descricao,
    concat(nome, ' ', sobrenome) as 'Cliente'
from Pedido
inner join Cliente on Pedido.idCliente = Cliente.idCliente
having Cliente = 'Ricardo Silva';

-- Qual a forma de pagamento de cada pedido?
select 
	p.idPedido,
    p.statusPedido,
    p.codRastreio,
    p.descricao,
    pg.formPagto
from Pedido as p
inner join relPedidoPagamento as r on p.idPedido = r.idPedido
	inner join Pagamento as pg on r.idPagto = pg.idPagto;
    
-- mostrar pedidos que a forma de pagto foi pix?
select 
	p.idPedido,
    p.statusPedido,
    p.codRastreio,
    p.descricao,
    pg.formPagto
from Pedido as p
inner join relPedidoPagamento as r on p.idPedido = r.idPedido
	inner join Pagamento as pg on r.idPagto = pg.idPagto
where pg.formPagto = 'pix';

-- filtrar pedidos Entregue?
select 
	idPedido,
    statusPedido,
    codRastreio,
    descricao,
    concat(nome, ' ', sobrenome) as 'Cliente'
from Pedido
inner join Cliente on Pedido.idCliente = Cliente.idCliente
where statusPedido = 'Entregue';

-- Listar estoque completo com as quantidades de cada produto?
select 
	p.descricao,
    p.classificacaoKids,
    p.categoria, 
    p.avaliacao,
    p.valor,
    pe.quantidade,
    e.localizacao
from Produto as p
inner join relProdutoEstoque as pe on p.idProduto = pe.idProduto
	inner join Estoque as e on pe.idEstoque = e.idEstoque;
    
-- Qual o produto com melhor avaliação dos clientes?
select * from Produto order by avaliacao desc limit 1;

-- filtrar vendas para pessoa juridica?
select 
	idPedido,
    statusPedido,
    codRastreio,
    descricao,
    concat(nome, ' ', sobrenome) as 'Cliente',
    tipo,
    cpfCnpj
from Pedido
inner join Cliente on Pedido.idCliente = Cliente.idCliente
having tipo = 'CNPJ';

-- agrupar os pedidos pelo status?
select 
    statusPedido,
    count(*) as 'Qtd'
from Pedido
group by statusPedido;

-- mostrar status do pedido e código de rastreio?
select 
	idPedido,
    statusPedido,
	codRastreio
from Pedido;