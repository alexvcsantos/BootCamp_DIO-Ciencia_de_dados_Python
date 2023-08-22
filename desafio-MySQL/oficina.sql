-- ============================================= Criar banco de dados ==========================================================
create schema oficina;

use oficina;

-- ============================================= Criar tabelas  ==========================================================
-- criar tabela Cliente
create table Cliente(
	idCliente int primary key auto_increment,
    nome varchar(100) not null,
    tipo enum('CPF', 'CNPJ') not null,
    cpfCnpj char(15) not null,
    endereco varchar(100),
    cidade varchar(45),
    estado char(2),
    contato varchar(20) not null,
    constraint un_Cliente_cpfCnpj unique (cpfCnpj)
);

-- criar tabela veiculo
create table Veiculo(
	idVeiculo int primary key auto_increment,
    fabricante varchar(45) not null,
    modelo varchar(45) not null,
    ano char(8) not null,
    placa char(8) not null,
    cor char(15) not null,
    idCliente int not null,
    constraint fk_Veiculo_idCliente foreign key (idCliente) references Cliente(idCliente)
);

-- criar tabela ordemservico
create table OrdemServico(
	idOs int primary key auto_increment,
    dataEntrada date not null,
    dataSaida date,
    km char(6) not null,
    combustivel ENUM('Etanol', 'Gasolina', 'Flex', 'Diesel', 'Elétrico') not null,
    descricao varchar(250) not null,
    observacao varchar(500),
    idVeiculo int not null,
    constraint fk_OrdemServico_idVeiculo foreign key (idVeiculo) references Veiculo(idVeiculo)
);

-- criar tabela Pagamento
create table Pagamento(
	idPagto int primary key auto_increment,
    formaPagto char(20) not null
);

-- criar tabela relPagamentoOrdemServico
create table relPagamentoOrdemServico(
	idOs int,
    idPagto int,
    valor float not null,
    constraint primary key (idOs, idPagto),
    constraint fk_relPagamentoOrdemServico_idOs foreign key (idOs) references OrdemServico(idOs),
    constraint fk_relPagamentoOrdemServico_idPagto foreign key (idPagto) references Pagamento(idPagto)
);

-- ============================================= inserindo dados ==========================================================
insert into Cliente(nome, tipo, cpfCnpj, endereco, cidade, estado, contato) values
	('Alex Victor', 'CPF', 12345678912, 'rua um, nº 2 - jardim morumbi', 'Holambra', 'SP', '19-997121515'),
    ('Miguel Rodirgues', 'CPF', 32132132132, 'rua dez, nº 10 - jardim botanico', 'Campinas', 'SP', '19-996222020'),
	('Famila Santos - ME', 'CNPJ', 10100101000120, 'rua bom sucesso, nº 1000 - jardim bom sucesso', 'Campinas', 'SP', '19-32231000');
select * from Cliente;

insert into Veiculo(fabricante, modelo, ano, placa, cor, idCliente) values
	('Chevrolet', 'Camaro', '2023', 'ABC2023', 'Amarelo', 2),
	('Toyota', 'Hilux', '2022', 'BBC2022', 'Prata', 3),
	('Ford', 'Ranger', '2023', 'DDD2020', 'Preto', 1),
	('Volkswagem', 'Polo', '2020', 'ACC2123', 'Branco', 3);
select * from Veiculo;
    
insert into OrdemServico(dataEntrada, dataSaida, km, combustivel, descricao, observacao, idVeiculo) values
	('2020-06-01', '2020-06-15', '20500', 'Flex', 'Verificar barulho suspensão dianteira', 'realizada troca coxim do amortecedor', 1),
    ('2021-04-15', '2021-04-18', '5092', 'Diesel', 'Realizar troca de Oleo e filtros', 'Serviço realizado', 2),
    ('2020-06-01', '2020-06-05', '125320', 'Diesel', 'Revisar freio, fazendo barulho e esta ruim.', 'Realizada a troca de disco e pastilha freio dianteiro', 3),
    ('2022-01-30', '2022-02-02', '185630', 'Flex', 'carro falando', 'realizado a troca do jogo de vela e bobina', 4),
    ('2022-02-20', null, '185700', 'Flex', 'Revisão geral', null, 4);
select * from OrdemServico;

insert into Pagamento(formaPagto) values ('Boleto'), ('Pix'), ('Cartão Débito'), ('Cartão Crédito'), ('Dinheiro');
select * from Pagamento;

insert into relPagamentoOrdemServico(idOs, idPagto, valor) values
	(1, 1, 255),
    (2, 2, 840),
    (3, 5, 650),
    (4, 3, 480);
select * from relPagamentoOrdemServico;

-- atualizar ordem serviço 5 - fechar os data saida e observações
update OrdemServico set dataSaida='2022-02-27', observacao='realizado um check-up geral. tudo ok' where idOs=5;
select * from OrdemServico;
-- inserir forma pagamento ordem serviço 5
insert into relPagamentoOrdemServico(idOs, idPagto, valor) values (5, 4, 80);

-- ============================================= Query ==========================================================

-- Quantos clientes tem na oficina?
select count(*) from Cliente;

-- ver todas Ordem Serviço que foram pagas com pix?
select 
	os.*,
    p.formaPagto,
    r.valor
from OrdemServico as os
inner join relPagamentoOrdemServico as r on os.idOs = r.idOs
	inner join Pagamento as p on r.idPagto = p.idPagto
where p.formaPagto = 'Pix';

-- recuperar todas Ordem serviço com o nome cliente, dados do veiculo e dados da Ordem serviço?
select
	c.nome,
    c.contato,
    v.fabricante,
    v.modelo,
    v.placa,
	os.*,
    p.formaPagto,
    r.valor
from Cliente as c
inner join Veiculo as v on c.idCliente = v.idCliente
	inner join OrdemServico as os on v.idVeiculo = os.idVeiculo
		inner join relPagamentoOrdemServico as r on os.idOs = r.idOs
			inner join Pagamento as p on r.idPagto = p.idPagto;

-- pegar todas Ordem do ano de 2020?
select * from OrdemServico where year(dataEntrada) = 2020;