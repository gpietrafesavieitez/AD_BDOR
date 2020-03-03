CLEAR SCREEN;
DROP TABLE pedido_tab FORCE;
DELETE FROM cliente_tab FORCE;
DROP TABLE cliente_tab FORCE;
DELETE FROM item_tab FORCE;
DROP TABLE item_tab FORCE;
DROP TYPE pedido_t FORCE;
DROP TYPE linea_pedido_t FORCE;
DROP TYPE linea_t FORCE;
DROP TYPE item_t FORCE;
DROP TYPE cliente_t FORCE;
DROP TYPE lista_tel_t FORCE;
DROP TYPE direccion_t FORCE;
CREATE TYPE lista_tel_t AS VARRAY(10) OF VARCHAR2(20);
/
CREATE TYPE direccion_t AS OBJECT(
calle VARCHAR2(200),
ciudad VARCHAR2(200),
prov CHAR(2),
codpos VARCHAR2(20));
/
CREATE TYPE cliente_t AS OBJECT(
clinum NUMBER,
clinomb VARCHAR2(200),
direccion direccion_t,
lista_tel lista_tel_t);
/
CREATE TYPE item_t AS OBJECT(
itemnum NUMBER,
precio NUMBER,
tasas NUMBER);
/
CREATE TYPE linea_t AS OBJECT(
linum NUMBER,
item REF item_t,
cantidad NUMBER,
descuento NUMBER);
/
CREATE TYPE lineas_pedido_t AS TABLE OF linea_t;
/
CREATE TYPE pedido_t AS OBJECT(
ordnum NUMBER,
cliente REF cliente_t,
fechpedido DATE,
fechentrega DATE,
pedido lineas_pedido_t,
direcentrega direccion_t);
/
CREATE TABLE cliente_tab OF cliente_t(clinum PRIMARY KEY);
CREATE TABLE item_tab OF item_t(itemnum PRIMARY KEY);
CREATE TABLE pedido_tab OF pedido_t(PRIMARY KEY (ordnum),SCOPE FOR (cliente) IS cliente_tab) NESTED TABLE pedido STORE AS linea_pedido_tab;
ALTER TABLE linea_pedido_tab ADD (SCOPE FOR (item) IS item_tab);
INSERT INTO item_tab VALUES(1004, 6750.00, 2);
INSERT INTO item_tab VALUES(1011, 4500.23, 2);
INSERT INTO item_tab VALUES(1534, 2234.00, 2);
INSERT INTO item_tab VALUES(1535, 3456.23, 2);
INSERT INTO item_tab VALUES(2004, 33750.00, 3);
INSERT INTO item_tab VALUES(3011, 43500.23, 4);
INSERT INTO item_tab VALUES(4534, 5034.00, 6);
INSERT INTO item_tab VALUES(5535, 34456.23, 5);
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
lista_tel_t());
INSERT INTO pedido_tab
SELECT 1001, REF(C),
SYSDATE,'10-MAY-1999',
lineas_pedido_t(),
NULL
FROM cliente_tab C
WHERE C.clinum= 1 ;
INSERT INTO THE (
SELECT P.pedido
FROM pedido_tab P
WHERE P.ordnum = 1001
)
SELECT 01, REF(S), 12, 0
FROM item_tab S
WHERE S.itemnum = 1534;
INSERT INTO THE (
SELECT P.pedido
FROM pedido_tab P
WHERE P.ordnum = 1001
)
SELECT 02, REF(S), 10, 10
FROM item_tab S
WHERE S.itemnum = 1535;
INSERT INTO pedido_tab
SELECT 2001, REF(C),
SYSDATE,'20-MAY-1999',
lineas_pedido_t(),
direccion_t('55 Madison Ave','Madison','WI','53715')
FROM cliente_tab C
WHERE C.clinum= 2;
INSERT INTO THE (
SELECT P.pedido
FROM pedido_tab P
WHERE P.ordnum = 2001
)
SELECT 10, REF(S), 1, 0
FROM item_tab S
WHERE S.itemnum = 1004;
INSERT INTO THE (
SELECT P.pedido
FROM pedido_tab P
WHERE P.ordnum= 2001
)
VALUES( linea_t(11, NULL, 2, 1) ) ;
INSERT INTO pedido_tab
SELECT 3001, REF(C),
SYSDATE,'30-MAY-1999',
lineas_pedido_t(),
NULL
FROM cliente_tab C
WHERE C.clinum= 3 ;
INSERT INTO THE (
SELECT P.pedido
FROM pedido_tab P
WHERE P.ordnum = 3001
)
SELECT 30, REF(S), 18, 30
FROM item_tab S
WHERE S.itemnum = 3011;
INSERT INTO THE (
SELECT P.pedido
FROM pedido_tab P
WHERE P.ordnum = 3001
)
SELECT 32, REF(S), 10, 100
FROM item_tab S
WHERE S.itemnum = 1535;
INSERT INTO pedido_tab
SELECT 3002, REF(C),
SYSDATE,'15-JUN-1999',
lineas_pedido_t(),
NULL
FROM cliente_tab C
WHERE C.clinum= 3 ;
INSERT INTO THE (
SELECT P.pedido
FROM pedido_tab P
WHERE P.ordnum = 3002
)
SELECT 34, REF(S), 200, 10
FROM item_tab S
WHERE S.itemnum = 4534;
INSERT INTO pedido_tab
SELECT 4001, REF(C),
SYSDATE,'12-MAY-1999',
lineas_pedido_t(),
direccion_t('34 Nave Oeste','Nules','CS','12876')
FROM cliente_tab C
WHERE C.clinum= 4;
INSERT INTO THE (
SELECT P.pedido
FROM pedido_tab P
WHERE P.ordnum = 4001
)
SELECT 41, REF(S), 10, 10
FROM item_tab S
WHERE S.itemnum = 2004;
INSERT INTO THE (
SELECT P.pedido
FROM pedido_tab P
WHERE P.ordnum = 4001
)
SELECT 42, REF(S), 32, 22
FROM item_tab S
WHERE S.itemnum = 5535;
/*1. Consultar a definicion da taboa clientes.*/
DESCRIBE cliente_tab;

/*2. Inserir na taboa de clientes un nuevo cliente con todos os seus datos.(inventaos)*/
INSERT INTO cliente_tab VALUES(6, 'hola', direccion_t('calle','ciudad','aa','codpos'), lista_tel_t('414-414-4444'));

/*3. Consultar e modificar o nome do cliente numero 2  (debe pasar a chamarse 'Jorge Lampara')*/
SELECT * FROM cliente_tab WHERE clinum=2;
UPDATE cliente_tab SET clinomb='Jorge Lampara' WHERE clinum=2;

/*4. Consultar e modificar o enderezo do cliente numero 2, que debera pasar a ser :
 '123 parchis','ceuta','ce','12345'*/
SELECT direccion FROM cliente_tab WHERE clinum=2;
UPDATE cliente_tab SET direccion=direccion_t('123 parchis','ceuta','ce','12345') WHERE clinum=2;

/*5. Consultar todos os datos do cliente numero 1 e engadir  un novo telefono a sua lista de telefonos.*/
SELECT * FROM cliente_tab WHERE clinum=1;

/*6. Amosar somentes o nome do cliente que realizou o pedido numero 1001.*/
SELECT DEREF(cliente).clinomb FROM pedido_tab WHERE ordnum=1001;

/*7a. Visualizar todos os detalles do client que realizou o pedido numero 1001.*/
SELECT DEREF(cliente) FROM pedido_tab WHERE ordnum=1001;

/*7b. amosar  o numero das lineas de pedido correspondentes a orde numero 3001.*/

/*7c. amosar codigo de cliente que fixo o pedido 3001*/
SELECT DEREF(cliente).clinum FROM pedido_tab WHERE ordnum=3001;

/*7d. amosar  o numero das lineas de pedidos correspondentes ao cliente de numero 3.*/

/*8. Visualizar o numero de todos los items que se han pedido en la orden numero  3001.*/

SHOW ERRORS;
