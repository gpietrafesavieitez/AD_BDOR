drop type enderezo force;
drop type taboa_anidada force;
drop table exemplo_taboa_anidada;
create or replace type enderezo as object
(
rua varchar2(25),
cidade varchar2(20),
codpost number(5)
);
/
create or replace type taboa_anidada as table of enderezo;
/
create table exemplo_taboa_anidada(
id number,
apelidos varchar2(25),
direc taboa_anidada
) nested table direc store as direc_anidada;
insert into exemplo_taboa_anidada values
(1,'suarez',taboa_anidada(
	enderezo('garcia barbon,1','vigo',36201),
	enderezo('garcia barbon,2','vigo',36205),
	enderezo('faisan,23','caceres','1023'),
	enderezo('burgos,2','toledo',20103)
	)
);
insert into exemplo_taboa_anidada values
	(2,'xocas',taboa_anidada(
	enderezo('estrela,1','vigo',36202),
	enderezo('berbes,2','lugo',28205)
	)
);

-- select anidada REPASO
select id,apelidos,cursor(select tt.rua from table (t.direc) tt where tt.cidade='vigo')from exemplo_taboa_anidada t;
-- amosar os enderezos en vigo cuyo id es 1 REPASO
select id,apelidos,cursor(select tt.rua from table (t.direc) tt where tt.cidade='vigo')from exemplo_taboa_anidada t where id=1;
-- PAra los casos que solo utilizamos consultas para una fila en concreto
select rua from the(select t.direc from exemplo_taboa_anidada t where id=1) where cidade='vigo';
--- Insert en taboa anidadda
insert into table(select direc from exemplo_taboa_anidada where id=1) values(enderezo('percebe,4','vigo',36222));


-- actualizar una direccion en la tabla anidada	
update table (select direc from exemplo_taboa_anidada where id = 1) p set p.rua= 'gato, 2' where p.codpost = 36222;

-- eliminar o sustituir una fila de la tabla anidada
update table (select direc from exemplo_taboa_anidada where id = 1) p set value(p)=enderezo('gato', 'barcelona', 86221) where value(p) = enderezo('garcia barbon,1', 'vigo', 36201);


