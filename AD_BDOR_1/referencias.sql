drop type empregadot force;
drop table empregado cascade constraints;
create type empregadot as object(
	nome varchar2(30), 
	xefe ref empregadot
);
/
create table empregado of empregadoT;


insert into empregado values ( empregadot('luis', null));
insert into empregado select empregadot('pedro', ref(e)) from empregado e where e.nome = 'luis';
select nome, deref(p.xefe) from empregado p;

select nome from empregado p where ref(p) = (select xefe from empregado where nome = 'pedro');
