/*
exercicio 29
coste_total

achego funcion coste_total, so debedes lanzala e posteriormente desenvolver a seguinte consulta dende a consola do SQL . Suponse que  que tedes creados e inseridos todos os datos do exercicio bdorexemploalumnos): 

Consulta:  Seleccionar o número de orde e o  coste total dos pedidos  feitos  polo cliente numero 3


/*
funcion coste_total

descricion: engade unha funcion chamada coste_total ao tipo pedido_t que devolte un numero que sera o resultado de calcular a suma dos valores das líneas de pedido correspondentes a
orde de pedido sobre la que se executa.
notas: 
- a palabra clave COUNT serve para contar o número de elementos de una taboa ou dun array.
Xunto ca instrucción LOOP permite iterar sobre os elementos dunha colección, no noso caso 
caso as líneas de pedido dunha orde.
- o SELECT e necesario porque Oracle non permite utilizar DEREF directamente no código
PL/SQL.
*/ 


ALTER TYPE pedido_t ADD MEMBER FUNCTION coste_total RETURN NUMBER cascade;

CREATE TYPE BODY pedido_t AS
MEMBER FUNCTION coste_total RETURN NUMBER IS
i INTEGER;
item item_t;
linea linea_t;
total NUMBER:=0;
BEGIN
FOR i IN 1..pedido.COUNT LOOP
linea:=pedido(i);
SELECT DEREF(linea.item) INTO item FROM DUAL;
total:=total + linea.cantidad * item.precio;
END LOOP;
RETURN total;
end;
end;
/

