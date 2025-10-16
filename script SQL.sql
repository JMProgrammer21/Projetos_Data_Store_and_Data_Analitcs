USE SHOPPLUS;
/* garantir que o MYSQL Aceite os caracteres especiais */
set global local_infile =1;
set names utf8mb4;
set character set utf8mb4;
set collation_connection = 'utf8mb4_0900_ai_ci';

/* importarção do arquivo Clientes */
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/clientes2.csv'
into table clientes
character set utf8mb4
fields terminated by ';'
enclosed by''''
lines terminated by '\n'
ignore 1 rows;

/* importarção do arquivo Vendedores*/
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Vendedores2.csv'
into table clientes
character set utf8mb4
fields terminated by ';'
enclosed by''''
lines terminated by '\n'
ignore 1 rows;

/* importarção do arquivo Produtos */
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/produtos2.csv'
into table produtos
character set utf8mb4
fields terminated by ';'
enclosed by''''
lines terminated by '\n'
ignore 1 rows;

/* importarção do arquivo telefone */
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/telefones2.csv'
into table telefone
character set utf8mb4
fields terminated by ';'
enclosed by''''
lines terminated by '\n'
ignore 1 rows;

/* importarção do arquivo Pedidos */
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pedidos1.csv'
into table pedidos
character set utf8mb4
fields terminated by ';'
enclosed by''''
lines terminated by '\n'
ignore 1 rows;

/*ligando e desligando a proteção do my sql, para não deletar erradamente */
SET SQL_SAFE_UPDATES = 0;
DELETE FROM formaspagamento;
SET SQL_SAFE_UPDATES = 1;

select *from ;
show create table pedidos ;

/* muda a posição da coluna, depois de ...*/
ALTER TABLE pedidos MODIFY COLUMN status_Pagamento varchar(50) AFTER id_pagamento;

/*mudar o nome da coluna */
ALTER TABLE pedidos CHANGE COLUMN status_pedido status_entrega varchar(50);

ALTER TABLE pedidos add	status_Pagamento varchar(50);

DESCRIBE clientes;

select telefone from clientes;
UPDATE clientes
SET telefone = NULL;
show create table clientes;
truncate	

/* habilitar e desabiitar o modo seguro*/
SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;  -- Para reabilitar o modo seguro após a atualização
ALTER TABLE clientes DROP COLUMN telefone;

SELECT *
FROM information_schema.columns 
WHERE table_name = 'clientes';
/*------------------------------------------------------------------*/
/*Quantidade de Pedidos realizados no mes de Dezembro*/
select count(id_cliente) from pedidos;

/* Quantidade de clientes que compraram no mês vigênte: "Dezembro"*/
select count(distinct id_cliente) as total_cliente
from pedidos where data_pedido between '01/12/2024' and '31/12/2024';

/*Faturamento total mês de Dezembro*/
select sum(valor_compra) from pedidos;
/*maior valor de compras, menor valor, e a média dos valores*/
select max(valor_compra),min(valor_compra),avg(valor_compra) from pedidos;

/*  top 5 clientes em compras( que fizeram mais pedidos)*/ 
select pedidos.id_cliente, clientes.nome, clientes.sobrenome, count(id_pedido) as total_pedidos
from pedidos
join clientes on pedidos.id_cliente = clientes.id_cliente
group by clientes.id_cliente, clientes.nome
order by total_pedidos desc
limit 5;

/*  top 5 clientes em compras( que fizeram menos pedidos)*/ 
select pedidos.id_cliente, clientes.nome, clientes.sobrenome, count(id_pedido) as total_pedidos
from pedidos
join clientes on pedidos.id_cliente = clientes.id_cliente
group by clientes.id_cliente, clientes.nome
order by total_pedidos asc
limit 5;

/* top 10 clientes em compras R$ ( que gastaram mais)*/
select id_cliente, sum(valor_compra) as total_gasto
from pedidos
group by id_cliente
order by total_gasto desc
limit 3;

/*Quantidade de Clientes por Estado?*/
select ESTADO, count(id_cliente) as QTD_Clientes_ESTADO
from clientes
group by ESTADO
order by QTD_Clientes_ESTADO desc;

/*Maior valor de compras por estado?*/
select Estado, sum(valor_compra) as Valor_Total
from pedidos 
join clientes on pedidos.id_cliente = clientes.id_cliente
group by clientes.Estado
order by Valor_Total desc;

/*Maior volume de compras por Estado?*/
select Estado, count(id_pedido) as Total_Pedido
from pedidos
join clientes on pedidos.id_cliente = clientes.id_cliente
group by clientes.Estado
order by Total_Pedido desc;

/*Produtos mais Vendidos*/
SELECT produtos.nome , count(id_pedido) as qtd_produto, produtos.categoria
from pedidos
join produtos on pedidos.id_produto = produtos.id_produto
group by produtos.nome, produtos.categoria 
order by qtd_produto desc;


/*Categoria de produtos mais vendidos por estado*/
select ESTADO, categoria, count(id_pedido) as qtd_pedido
from pedidos
join produtos on pedidos.id_produto = produtos.id_produto
join clientes on pedidos.id_cliente = clientes.id_cliente
group by Estado, categoria
order by Estado, qtd_pedido desc;

/*Valor das compras por tipos de pagamentos*/
select tipo, sum(valor_compra) as total_compras
from pedidos
join formaspagamento on formaspagamento.id_formaspag = pedidos.id_pagamento
group by formaspagamento.tipo
order by total_compras desc;

/*QUANTIDADE DE PEDIDOS POR ESTATUS*/
SELECT STATUS_PEDIDO, COUNT(ID_PEDIDO) FROM PEDIDOS 
GROUP BY STATUS_PEDIDO ;

/*Quais tipos de pagamentos tem mais fraudes*/
SELECT formaspagamento.tipo, STATUS_PEDIDO, COUNT(ID_PEDIDO) as qtd_pedido
from pedidos 
left join formaspagamento on id_formaspag = pedidos.id_pagamento
where STATUS_PEDIDO = 'fraude'
group by  STATUS_PEDIDO, formaspagamento.id_formaspag;

/*Resposta 'Cartão Débito', 'dinheiro', 'boleto ambos com 17 fraudes*/

/*Quais tipos de pagamentos tem mais cancelamentos*/
SELECT formaspagamento.tipo, STATUS_PEDIDO, COUNT(ID_PEDIDO) as qtd_pedido
from pedidos 
left join formaspagamento on id_formaspag = pedidos.id_pagamento
where STATUS_PEDIDO = 'CANCELADO'
group by  STATUS_PEDIDO, formaspagamento.id_formaspag;

/*Resposta 'Cartão Débito', 'CANCELADO', '11', segundo lugar 'Cheque', 'CANCELADO', '7'*/


/*Quais tipos de pagamentos tem mais sucesso*/
SELECT formaspagamento.tipo, STATUS_PEDIDO, COUNT(ID_PEDIDO) as qtd_pedido
from pedidos 
left join formaspagamento on id_formaspag = pedidos.id_pagamento
where STATUS_PEDIDO = 'SUCESSO'
group by  STATUS_PEDIDO, formaspagamento.id_formaspag;

/*Resposta 'Cheque', 'SUCESSO', '11', segundo lugar 'Pix', 'SUCESSO', '10' */

/*Quais tipos de pagamentos tem mais reclamações*/ 

SELECT formaspagamento.tipo, STATUS_PEDIDO, COUNT(ID_PEDIDO) as qtd_pedido
from pedidos 
left join formaspagamento on id_formaspag = pedidos.id_pagamento
where STATUS_PEDIDO = 'RECLAMAÇÃO'
group by  STATUS_PEDIDO, formaspagamento.id_formaspag;

/*Resposta 'Cartão Débito', 'RECLAMAÇÃO', '11', segundo lugar 'Cartão Crédito', 'RECLAMAÇÃO', '10' */

/*total de vendas(R$) por vendedores*/
select vendedores.id_vendedor,vendedores.nome, sum(valor_compra) as Valor_total
from pedidos
left join vendedores on vendedores.id_vendedor = pedidos.id_vendedor
group by id_vendedor, vendedores.nome
order by Valor_total desc;

/*total de vendas(quantidade) por vendedores*/
select vendedores.id_vendedor,vendedores.nome, count(id_pedido) as qtd_total
from pedidos
left join vendedores on vendedores.id_vendedor = pedidos.id_vendedor
group by id_vendedor, vendedores.nome
order by qtd_total desc;

/*média de vendas por vendedores*/
select vendedores.id_vendedor,vendedores.nome, avg(valor_compra) as Valor_medio
from pedidos
left join vendedores on vendedores.id_vendedor = pedidos.id_vendedor
group by id_vendedor, vendedores.nome
order by Valor_medio desc;

/*Quantidade de pedidos fraudados por vendedores*/
select pedidos.id_vendedor,vendedores.nome, count(id_pedido) as qtd_pedidos
from pedidos
join vendedores on vendedores.id_vendedor = pedidos.id_vendedor
where pedidos.status_pedido = 'fraude'
group by pedidos.id_vendedor,vendedores.nome
order by qtd_pedidos desc;

/*Quantidade de pedidos de reclamações  por vendedores*/
select pedidos.id_vendedor,vendedores.nome, count(id_pedido) as qtd_pedidos
from pedidos
join vendedores on vendedores.id_vendedor = pedidos.id_vendedor
where pedidos.status_pedido = 'reclamação'
group by pedidos.id_vendedor,vendedores.nome
order by qtd_pedidos desc;

/*Quantidade de pedidos de cancelados por vendedores*/
select pedidos.id_vendedor,vendedores.nome, count(id_pedido) as qtd_pedidos
from pedidos
join vendedores on vendedores.id_vendedor = pedidos.id_vendedor
where pedidos.status_pedido = 'cancelado'
group by pedidos.id_vendedor,vendedores.nome
order by qtd_pedidos desc;

/*Quantidade de pedidos com sucesso por vendedores*/
select pedidos.id_vendedor,vendedores.nome, count(id_pedido) as qtd_pedidos
from pedidos
join vendedores on vendedores.id_vendedor = pedidos.id_vendedor
where pedidos.status_pedido = 'sucesso'
group by pedidos.id_vendedor,vendedores.nome
order by qtd_pedidos desc;

/*Taxa de sucesso de pedidos */
SELECT 
    COUNT(CASE WHEN status_pedido = 'sucesso' THEN id_pedido END) * 1.0 / COUNT(id_pedido) AS taxa_sucesso
FROM pedidos;

/*Taxa de cancelamentos de pedidos */
SELECT 
    COUNT(CASE WHEN status_pedido = 'cancelado' THEN id_pedido END) * 1.0 / COUNT(id_pedido) AS taxa_sucesso
FROM pedidos;

/*Taxa de reclamações de pedidos */
SELECT 
    COUNT(CASE WHEN status_pedido = 'reclamação' THEN id_pedido END) * 1.0 / COUNT(id_pedido) AS taxa_sucesso
FROM pedidos;

/*Taxa de fraudes de pedidos */
SELECT 
    COUNT(CASE WHEN status_pedido = 'fraude' THEN id_pedido END) * 1.0 / COUNT(id_pedido) AS taxa_sucesso
FROM pedidos;

/*Recomendações, focar em um determinado nicho?, focar em um Estado?, demitir algum vendedor?, remover algum produto?, focar em algum produto?*/


show create table clientes;
