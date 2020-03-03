alter SESSION set NLS_DATE_FORMAT = 'DD.MM.YYYY';
set heading off;

drop type enderezo force;
create or replace type enderezo as object(
	rua varchar2(24), 
	cidade varchar2(20),
	codpost number(5), 

	member function get_rua return varchar2
);
/

create or replace type body enderezo as member function get_rua return varchar2 is
	begin
		return rua;
	end;
end;
/

drop type persoa force;
create or replace type persoa as object(
	codigo number,
	nome varchar2(25), 
	enderezoT Enderezo, 
	datan date
);
/

drop table alumnos cascade constraints;
create table alumnos of persoa(
	codigo primary key
);



insert into alumnos values (1, 'ana', enderezo('urzaiz,27', 'vigo', 36201), '23/4/1980');
insert into alumnos values (2, 'pedro', enderezo('burgos,2', 'vigo', 36204), '23/4/1979');
insert into alumnos values (3, 'juan', enderezo('camelias,21', 'vigo', 36206), '2/4/1981');
insert into alumnos values (4, 'eva', enderezo('pino,29', 'lugo', 34206), '12/4/1982');
-- select * from persoa where enderezoT.cidade = 'vigo';
-- select a.nome, a.enderezo.get_rua() from alumnos a where a.enderezoT.cidade = 'vigo';
-- select sum(a.enderezoT.codpost) from alumnos a where a.enderezoT.cidade = 'vigo';



drop type telefono force;
create type telefono as varray(3) of varchar2(9);
/

drop table axenda cascade constraints;
create table axenda(
	nome varchar2(15),
	telefonos telefono
);


insert into axenda values('luis', telefono('1234', '4567', '8143'));
insert into axenda values('marta', telefono('7777', '8888'));
-- update axenda a set a.telefonos = telefono('7777', 9999) where a.nome = 'marta';


drop type taboa_anidada force;
create type taboa_anidada as table of enderezo;
/

drop table TPrincipal;
create table TPrincipal(
	id number,
	apellidos varchar2(25),
	enderezos taboa_anidada)
	nested table enderezos store as enderezos_anidada
;

insert into TPrincipal values ( 1, 'rodriguez', taboa_anidada(enderezo('colon,1', 'vigo',36201), 
							      enderezo('torrecedeira,45', 'vigo',36207), 
							      enderezo('faisan,3', 'vigo',36205), 
							      enderezo('corrala,32', 'toledo',36543)
							     )
			      );

insert into TPrincipal values ( 2, 'bieitez', taboa_anidada(enderezo('tejon,1', 'huesca',36501), 
							    enderezo('buho,43', 'madrid',36442)
							   )
			      );

							      

drop type enderezo force;
create or replace type enderezo as object
(
rua varchar2(25),
cidade varchar2(20),
codpost number(5)
);
/




