drop type tipo_equipo force;
drop type tipo_xogador force;
drop table taboa_equipos cascade constraints;
drop table taboa_xogadores_scope cascade constraints;
create type tipo_equipo as object(
	id_equipo number,
	nome varchar2(20),
	data_creacion date,
	posicion number
);
/
create table taboa_equipos of tipo_equipo;


create type tipo_xogador as object(
	id_xogador number,
	equipo ref tipo_equipo,
	data_alta date, 
	direc enderezo
);
/

create table taboa_xogadores_scope of tipo_xogador(
	primary key (id_xogador),
	scope for (equipo) is taboa_equipos
);

insert into taboa_equipos values (tipo_equipo(1,'zap','21/1/2000', 1));
insert into taboa_xogadores_scope 
	select 1, ref(te), '10/1/2020', enderezo ('garcia barbon','vigo', 36201)
	from taboa_equipos te where id_equipo=1;
CREATE TABLE taboa_xogadores_ref OF tipo_xogador(PRIMARY KEY (id_xogador), equipo REFERENCES taboa_equipos);
INSERT INTO taboa_xogadores_ref
	select 1, ref(te), '10/1/2020', enderezo ('garcia barbon','vigo', 36201)
	from taboa_equipos te where id_equipo=1;
