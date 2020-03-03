DROP TABLE empregadosbdor;
DROP TYPE tipo_emp;
CREATE TYPE tipo_emp AS object(nome VARCHAR2(10), edade NUMBER);
/
CREATE TABLE empregadosbdor(id NUMBER, emp tipo_emp, salario NUMBER);
INSERT INTO empregadosbdor VALUES(1, tipo_emp('luis',23), 1800);
INSERT INTO empregadosbdor VALUES(2, tipo_emp('ana',30), 2100);
INSERT INTO empregadosbdor VALUES(3, tipo_emp('pedro',40), 1800);
COMMIT;
