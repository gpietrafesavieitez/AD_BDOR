/*
queremos crear unha base obxecto relacional en base aos cos seguintes tipos de objectos :
lista_tel_t:  un varray de ata 10 numeros de telefono de 20 caracres cada  
direccion_t;  un tipo obxecto para almacenar os datos de enderezos cos seguintes campos:
	calle : 200 caracteres
	ciudad : 200 caracteres
	prov : provincia con  2 caracteres
	codpos: 20 caractres ;
cliente_t; un tipo obxecto para almacenar os datos de clientes cos seguintes campos:
	clinum , contera o numero do cliente de tipo number
	clinomb,  contera o nome do cliente de tipo 200 caracteres
	direccion, contera o enderezo do cliente de tipo direccion_t,
	lista_tel, contera os telefonos dos clientes de tipo lista_tel_t ;
item_t: un tipo obxecto para almacenar os datos de produtos  cos seguintes campos:
	itemnum, contera o numero do produto de tipo number
	precio,  contera o precio do produto de tipo NUMBER,
	tasas, contera as tasas do produto de tipo NUMBER) ;
linea_t:un tipo obxecto para almacenar unha linea de pedido cos seguintes campos:
	linum, contera o numero dunha linea dun pedido de tipo number
	item , contera unha referencia ao item ao que se refire unha linea de pedido, de tipo item_t
	cantidad, contera o numero de items do produto ao que se refire unha linea de pedido , tipo number 
	descuento, contera o desconto aplicado a linea de pedido , tipo number
lineas_pedido_t : un tipo obxecto para almacenar unha taboa que e un conxunto das lineas de pedidos , de tipo linea_t
pedido_t:  un tipo obxecto para almacenar un pedido 
	ordnum contera  o  numero do pedido de tipo NUMBER,
	cliente  contera a referencia a o cliente que fixo o pedido, de tipo cliente_t
	fechpedido , contera a data do pedido,  de tipo Date
	fechentrega , contera a data da entrga do pedido, de tipo date
	pedido , contera al lineas do pedido , de tipo lineas_pedido_t
	direcentrega , contera o enderezo de entrega do pedido, de tipo direccion_t

crearemos tres taboas que utilizan estes tipos de obxectos

cliente_tab de tipo cliente_t que usara como clave primaria o campo clinum
item_tab de tipo tiem_t que usara como clave primaria o campo itemnum
pedido_tab de tipo pedido_t que usara como clave primaria o campo ordnum e usara como referencia para o seu campo cliente a taboa cliente_tab en modo SCOPE. tamen indicaremos nesta taboa que as lineas de pedido deste pedido (campo pedido) seran almacenadas na tabo anidada lineas_pedido_tab.

alteramos a tabla lineas_pedido_tab para indicar que a referencia do campo item e a taboa item_tab

*/


DROP TABLE pedido_tab cascade constraint;
drop table item_tab cascade constraint;
drop table cliente_tab cascade constraint;
DROP TYPE pedido_t force;
DROP TYPE lineas_pedido_t force;
DROP TYPE linea_t force;
DROP TYPE item_t force;
DROP TYPE cliente_t force;
DROP TYPE direccion_t force;
DROP TYPE lista_tel_t force;
-- 

CREATE TYPE lista_tel_t AS VARRAY(10) OF VARCHAR2(20) ;
/
CREATE TYPE direccion_t AS OBJECT (
calle VARCHAR2(200),
ciudad VARCHAR2(200),
prov CHAR(2),
codpos VARCHAR2(20)) ;
/
CREATE TYPE cliente_t AS OBJECT (
clinum NUMBER,
clinomb VARCHAR2(200),
direccion direccion_t,
lista_tel lista_tel_t) ;
/
CREATE TYPE item_t AS OBJECT (
itemnum NUMBER,
precio NUMBER,
tasas NUMBER) ;
/
CREATE TYPE linea_t AS OBJECT (
linum NUMBER,
item REF item_t,
cantidad NUMBER,
descuento NUMBER) ;
/
CREATE TYPE lineas_pedido_t AS TABLE OF linea_t;
/
CREATE TYPE pedido_t AS OBJECT (
ordnum NUMBER,
cliente REF cliente_t,
fechpedido DATE,
fechentrega DATE,
pedido lineas_pedido_t,
direcentrega direccion_t) ;
/

CREATE TABLE cliente_tab OF cliente_t
(clinum PRIMARY KEY);

CREATE TABLE item_tab OF item_t
(itemnum PRIMARY KEY) ;

-- no seguinte nested hai un erro no cript orixinal, onde puña ... STORE AS Pedido_tab,  puxen STORE AS lineas_pedido_tab
CREATE TABLE pedido_tab OF pedido_t
(ordnum PRIMARY KEY,
SCOPE FOR (cliente) IS cliente_tab)
NESTED TABLE pedido STORE AS lineas_pedido_tab ;

-- no seguinte alter hai un erro no script orixinal , onde puña ALTER TABLE pedido_tab por ALTER_TABLE lineas_pedido_tab
ALTER TABLE lineas_pedido_tab ADD (SCOPE FOR (item) IS item_tab);

-- para probar se se quere (opcional) : impedir que se podan repetir duas linas de pedido co mesmo numero de linea (isto ten un problema posto que non podo repetir o numero das lineas de pedido nin sequera ainda que pertezan a pedidos distintos)
-- ALTER TABLE lineas_pedido_tab ADD primary key (linum);

REM inserción en la tabla ITEM_TAB************************
INSERT INTO item_tab VALUES(1004, 6750.00, 2);
INSERT INTO item_tab VALUES(1011, 4500.23, 2);
INSERT INTO item_tab VALUES(1534, 2234.00, 2);
INSERT INTO item_tab VALUES(1535, 3456.23, 2);
INSERT INTO item_tab VALUES(2004, 33750.00, 3);
INSERT INTO item_tab VALUES(3011, 43500.23, 4);
INSERT INTO item_tab VALUES(4534, 5034.00, 6);
INSERT INTO item_tab VALUES(5535, 34456.23, 5);
REM inserción en la tabla CLIENTE_TAB*********************
INSERT INTO cliente_tab
VALUES (
1, 'Lola Caro',
direccion_t('12 Calle Lisboa', 'Nules', 'CS', '12678'),
lista_tel_t('415-555-1212')) ;
INSERT INTO cliente_tab
VALUES (
2, 'Jorge Luz',
direccion_t('323 Calle Sol', 'Valencia', 'V', '08820'),
lista_tel_t('609-555-1212','201-555-1212')) ;
INSERT INTO cliente_tab
VALUES (
3, 'Juan Perez',
direccion_t('12 Calle Colon', 'Castellon', 'ES', '12001'),
lista_tel_t('964-555-1212', '609-543-1212',
'201-775-1212','964-445-1212')) ;
INSERT INTO cliente_tab
VALUES (
4, 'Ana Gil',
direccion_t('5 Calle Sueca', 'Burriana', 'ES', '12345'),
lista_tel_t()) ;


REM inserción en la tabla PEDIDO_TAB***************************
/* 
Nótese cómo en estas definiciones se utiliza el operador REF para obtener una referencia a un objeto
de cliente_tab y almacenarlo en la columna de otro objeto de pedido_tab. La palabra clave THE se
utiliza para designar la columna de las tuplas que cumplen la condición del WHERE, donde se deben
realizar la inserción. Las tuplas que se insertan son las designadas por el segundo SELECT, y el
objeto de la orden debe existir antes de comenzar a insertar líneas de pedido.
*/
REM Pedidos del cliente 1**********************************
-- pedido 1001
INSERT INTO pedido_tab SELECT 1001, REF(C),SYSDATE,'10-MAY-1999',lineas_pedido_t(),NULL
FROM cliente_tab C WHERE C.clinum= 1 ;
-- linea de pedido 01
INSERT INTO THE (SELECT P.pedido FROM pedido_tab P WHERE P.ordnum = 1001) SELECT
 01, REF(S), 12, 0 FROM item_tab S WHERE S.itemnum = 1534;
-- linea de pedido  02
INSERT INTO THE (SELECT P.pedido FROM pedido_tab P WHERE P.ordnum = 1001) SELECT 
02, REF(S), 10, 10 FROM item_tab S WHERE S.itemnum = 1535;


REM Pedidos del cliente 2************************************
-- pedido 2001 
INSERT INTO pedido_tab SELECT 2001, REF(C), SYSDATE,'20-MAY-1999', lineas_pedido_t(),direccion_t('55 Madison Ave','Madison','WI','53715') FROM cliente_tab C WHERE C.clinum= 2;
-- lina de pedido  10
INSERT INTO THE (SELECT P.pedido FROM pedido_tab P WHERE P.ordnum = 2001) SELECT
 10, REF(S), 1, 0  FROM item_tab S WHERE S.itemnum = 1004;
-- linea de pedido  11
INSERT INTO THE (SELECT P.pedido FROM pedido_tab P WHERE P.ordnum= 2001) VALUES( linea_t(11, NULL, 2, 1) ) ;

REM  pedido del cliente 3************************************
-- pedido 3001 
INSERT INTO pedido_tab SELECT 3001, REF(C), SYSDATE,'30-MAY-1999',lineas_pedido_t(),NULL FROM cliente_tab C
WHERE C.clinum= 3 ;
-- lina de pedido  30
INSERT INTO THE (SELECT P.pedido FROM pedido_tab P WHERE P.ordnum = 3001) SELECT
 30, REF(S), 18, 30 FROM item_tab S WHERE S.itemnum = 3011;
-- lina de pedido  32
INSERT INTO THE (SELECT P.pedido FROM pedido_tab P WHERE P.ordnum = 3001) SELECT
 32, REF(S), 10, 100 FROM item_tab S WHERE S.itemnum = 1535;

REM otro pedido de cliente 3 *****************************************
-- pedido 3002
INSERT INTO pedido_tab SELECT 3002, REF(C), SYSDATE,'15-JUN-1999',lineas_pedido_t(),NULL FROM cliente_tab C
WHERE C.clinum= 3 ;
-- lina de pedido 34
INSERT INTO THE (SELECT P.pedido FROM pedido_tab P WHERE P.ordnum = 3002) SELECT
 34, REF(S), 200, 10 FROM item_tab S WHERE S.itemnum = 4534;

REM Pedidos del cliente 4************************************
-- pedido 4001
INSERT INTO pedido_tab SELECT 4001, REF(C),SYSDATE,'12-MAY-1999',lineas_pedido_t(),direccion_t('34 Nave Oeste','Nules','CS','12876') FROM cliente_tab C WHERE C.clinum= 4;
-- lina de pedido 41
INSERT INTO THE (SELECT P.pedido FROM pedido_tab P WHERE P.ordnum = 4001) SELECT
 41, REF(S), 10, 10 FROM item_tab S WHERE S.itemnum = 2004;
-- lina de pedido 42
INSERT INTO THE (SELECT P.pedido FROM pedido_tab P WHERE P.ordnum = 4001) SELECT
 42, REF(S), 32, 22 FROM item_tab S WHERE S.itemnum = 5535;

/*
engadir unha funcion chamada coste_total ao tipo pedido_t que devolte un numero que sera o resultado de calcular a suma dos valores das líneas de pedido correspondentes a
orde de pedido sobre la que se executa.
notas: 
- a palabra clave COUNT serve para contar o número de elementos de una taboa ou dun array.
Xunto ca instrucción LOOP permite iterar sobre os elementos dunha colección, no noso caso 
caso as líneas de pedido dunha orde.
- o SELECT e necesario porque Oracle non permite utilizar DEREF directamente no código
PL/SQL.
*/ 



rem **************************************************

select ' 1. Consultar a definición da taboa clientes.' from dual;
describe cliente_tab;

select '2. Inserir na taboa de clientes un nuevo cliente con todos os seus datos. ' from dual;
insert into cliente_tab values(5, 'John smith', direccion_t('67 rue de percebe', 'Gijon', 'AS',
'73477'),lista_tel_t('7477921749', '83797597827'));

select '3. Consultar e modificar o nome do cliente numero 2 ' from dual;
select clinomb from cliente_tab where clinum=2;
update cliente_tab set clinomb='Pepe Puig' where clinum=5;

select '4. Consultar e modificar o enderezo do cliente número 2. ' from dual;
select direccion from cliente_tab where clinum=2;
update cliente_tab set direccion=direccion_t('Calle Luna','Castello','CS','68734') where clinum=2;

select '5. Consultar todos os datos do cliente numero 1 e engadir  un novo teléfono a sua lista de teléfonos.' from dual;
select * from cliente_tab where clinum=1;
select value(C) from cliente_tab C where C.clinum=1;
update cliente_tab set lista_tel=lista_tel_t('415-555-1212','6348635872') where clinum=1;

select '6. Amosar o nome do cliente que realizou o pedido numero de orden 1001.' from dual;
select o.cliente.clinomb from pedido_tab o where o.ordnum=1001;

select ' 7a. Visualizar todos los detalles do cliente que  realizou o pedido  número 1001.' from dual;
select DEREF(o.cliente) from pedido_tab o where o.ordnum=1001;

select ' 7b. amosar  o numero das lineas de pedido correspondentes á orde número 3001.' from dual;
select cursor(select p.linum from Table(o.pedido) p) from pedido_tab o where o.ordnum=3001;

select '7c. amosar codigo de cliente que fixo o pedido 3001' from dual;
select DEREF(o.cliente).clinum  from pedido_tab o where o.ordnum=3001;

select '7d. amosar  o numero das lineas de pedidos correspondentes ao cliente de numero 3.' from dual;
select cursor(select p.linum from Table(o.pedido) p) from pedido_tab o where DEREF(o.cliente).clinum=3;

select '8. Visualizar o número de todos los items que se han pedido en la orden /Users/ricardo2009/Downloads/5_tiempo.pdfnúmero 3001. ' from dual;
select cursor(select p.item.itemnum from Table(o.pedido) p) from pedido_tab o where o.ordnum=3001;


