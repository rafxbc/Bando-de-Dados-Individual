--CRIAÇÃO DE TABELAS

create table public.endereco (
end_cd_id SERIAL primary key not null,
end_tx_cep varchar (10) not null,
end_tx_bairro varchar (20) not null,
end_tx_num int4 not null
)

create table public.profissional (
pro_cd_id SERIAL primary key not null,
pro_tx_nome varchar (30) not null,
pro_tx_funcao varchar (30) not null,
pro_int_idade int not null
)

create table public.delegacia (
del_cd_id SERIAL primary key not null,
del_tx_nome varchar (50) not null,
del_tx_hrinicio varchar (5) not null,
del_tx_hrfim varchar (5)not null,
del_fk_end int4 not null,
foreign key (del_fk_end) references public.endereco (end_cd_id)
)

create table public.registro_denuncia(
rd_cd_id SERIAL primary key not null,
rd_tx_ocorrencia varchar (30) not null,
rd_tx_nome_vitima varchar (20) null,
rd_int_idade_vitima int4 null,
rd_tx_horario_oc varchar (5) not null,
rd_fk_end int4 not null,
foreign key (rd_fk_end) references public.endereco (end_cd_id)
)

create table public.investigacao (
in_fk_rg int4 not null,
in_fk_pro int4 not null,
in_fk_del int4 not null,
foreign key (in_fk_rg) references public.registro_denuncia (rd_cd_id),
foreign key (in_fk_pro) references public.profissional (pro_cd_id),
foreign key (in_fk_del) references public.delegacia (del_cd_id)

)

-- inserts 
insert into public.endereco (end_tx_cep, end_tx_bairro, end_tx_num) 
values
('25001-234', 'Centro', 2),
('25002-345', 'Quitandinha', 345),
('25003-456', 'Itaipava', 627),
('25004-567', 'Valparaíso', 92),
('25005-678', 'Corrêas', 1002),
('25006-789', 'Cascatinha', 264),
('25007-890', 'Mosela', 512),
('25008-901', 'Bingen', 32),
('25009-123', 'Castelânea', 12),
('25010-234', 'Pedro do Rio', 34);

insert into public.registro_denuncia (rd_tx_ocorrencia, rd_tx_nome_vitima, rd_int_idade_vitima, rd_tx_horario_oc, rd_fk_end)
values 
('Assassinato', 'João Silva', 18, '23:00', 1),
('Cyber Ataque', 'Itaú', null, '03:00', 2),
('Assédio Sexual', 'Maria Clara', 25, '13:00', 3),
('Tráfico de Drogas', null, null, '02:00', 4),
('Assassinato', 'Matheus José', 27,'00:32', 5)


insert into public.profissional (pro_tx_nome, pro_tx_funcao, pro_int_idade)
values 
('Ana Paula', 'Delegada', 36),
('Júlia', 'TI', 20),
('Eduardo', 'Policial Civil', 28),
('Caio', 'Policial Rodoviário', 39),
('Luísa', 'Perita Criminal', 42)


insert into public.delegacia (del_tx_nome, del_tx_hrinicio, del_tx_hrfim, del_fk_end)
values
('Policia Civil', '09:00', '18:00', 6),
('Cyber Crimes', '05:00', '23:00', 7),
('Del. Feminina', '05:00', '00:00', 8),
('Del. Tráfico', '00:00', '00:00', 9),
('Del. Pericia', '10:00', '20:00', 10)

insert into public.investigacao (in_fk_rg, in_fk_pro, in_fk_del)
values
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5)

--CONSULTAS CONTEXTUALIZADAS

-- informações sobre uma denuncia:

select	p.pro_tx_nome as NomeProfissional,
		p.pro_tx_funcao as FuncaoProfissional,
		i.in_fk_rg as Ocorrencia,
		i.in_fk_del as Delegacia
	
		
from public.investigacao i
join public.profissional p on p.pro_cd_id = i.in_fk_pro

-- quantas delegacias estão abertas a um horário x:

select del_tx_nome as Delegacias_Abertas
from public.delegacia
where del_tx_hrinicio <= '08:00'
group by del_tx_nome

-- quantas ocorrrencias x aconteceram:

select count (rd_tx_ocorrencia) as Numero_Assassinatos
from public.registro_denuncia 
where rd_tx_ocorrencia = 'Assassinato'
