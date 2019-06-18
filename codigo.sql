-- Exercício 1

-- Questão a
alter table animal add column dataUltimaSolicitacao date; 

-- Questão b
create or replace function logDataUltimaSolicitacao()
	returns trigger as $triggerDataUltimaSolicitacao$
begin
	
	if TG_OP = 'INSERT' then
		if NEW.datasolicitacao is not null then
			update animal
				set dataUltimaSolicitacao = NEW.datasolicitacao
				where idanimal = NEW.idanimal;
			return NEW;
		end if;
	end if;

	if TG_OP = 'UPDATE' then
		if NEW.datasolicitacao is not null then
			update animal
				set dataUltimaSolicitacao = NEW.datasolicitacao
				where idanimal = NEW.idanimal;
			return NEW;
		end if;
	end if;

end;
$triggerDataUltimaSolicitacao$ language plpgsql;


create trigger triggerDataUltimaSolicitacao
	before insert or update
	on solicita
	for each row execute procedure logDataUltimaSolicitacao();


insert into solicita(datasolicitacao, hora, valor, idanimal, idservico, idpessoa, matric)
	values('2019-06-18', '10:26:00', 40.00, 1, 1, 1, null);


select * from animal;
select * from solicita;

-- Questão c
create or replace view selecionaAnimal as
	select * from animal order by animal.dataUltimaSolicitacao DESC;

-- Questão d
create or replace function showSolicitacao(idAnimal integer)
	returns table(
		dataUltimaSolicitacao date,
		solicitacao varchar(40),
		valor numeric(10, 2)	
	)
	as $$
begin
	return query
	select solicita.datasolicitacao, servicos.descricao, solicita.valor
		from solicita
			join animal using(idAnimal)
			join servicos using(idServico)
		where animal.idAnimal = $1;
end;
$$ language plpgsql;


-- Exercício 2
-- Questão a
alter table pessoas add column dataUltimaVenda date;

-- Questao b
create or replace function logDataUltimaVenda()
	returns trigger as $triggerDataUltimaVenda$
begin
	if TG_OP = 'INSERT' then
		if NEW.datanf is not null then
			update pessoas
				set dataUltimaVenda = NEW.datanf
					where idPessoa = NEW.idProp;
			return NEW;
		end if;
	end if;
	if TG_OP = 'UPDATE' then
		if NEW.datanf is not null then
			update pessoas
				set dataUltimaVenda = NEW.datanf
					where idPessoa = NEW.idProp;
			return NEW;
		end if;
	end if;
end;
$triggerDataUltimaVenda$ language plpgsql;


create trigger triggerDataUltimaVenda
	before insert or update
	on nf
	for each row execute procedure logDataUltimaVenda(); 

insert into nf (numnf, datanf, tipo, atualizada, idfornecedor, idprop)
	values(3561, '2019-06-18', 1, 0, 1, 2);

select * from nf;
select * from pessoas;

--- Questão c
create or replace view selecionaPessoas as
	select * from pessoas order by pessoas.dataUltimaVenda DESC;


--- Questao d
create or replace function showPessoa(idAnimal integer)
	returns table(
		dataUltimaSolicitacao date,
		solicitacao varchar(40),
		valor numeric(10, 2)	
	)
	as $$
begin
	return query
	select solicita.datasolicitacao, servicos.descricao, solicita.valor
		from solicita
			join animal using(idAnimal)
			join servicos using(idServico)
		where animal.idAnimal = $1;
end;
$$ language plpgsql;