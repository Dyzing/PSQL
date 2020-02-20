drop function if exists prohiber();
drop trigger if exists aristote;

drop table if exists eleveur;
drop table if exists adresse;
drop table if exists elevage;

drop type if exists t_adresse;
drop type if exists t_elevage_type;




create type t_elevage_type as (
		animal	varchar(30),
		ageMin	int,
		nbrMax	int
);


create type t_adresse as (
		nrue	int,
		rue	varchar(30),
		ville	varchar(30),
		code_postale	int
);

create table elevage of t_elevage_type ;
create table adresse of t_adresse;

create table eleveur (
		licence	int,
		elevage	t_elevage_type,
		adresse t_adresse
);
		
insert into elevage values ('poisson', 2, 150);
insert into elevage values ('canidé', 0, 999);
insert into elevage values ('reptiles', 0, 2);
insert into elevage values ('ovin', 12, 50);

insert into adresse values (2, 'boulevard lavoisier', 'Angers', 49000);
insert into adresse values (119, 'rue louis moron', 'Brisssac-Quincé', 49320);
insert into adresse values (69, 'rue cambrousse', 'Châteauroux', 36000);
insert into adresse values (0, 'rue bobo', 'Paris', 75004);

insert into eleveur values (1, (select e from elevage e where animal='poisson'), (select a from adresse a where code_postale=49000));
insert into eleveur values (2, (select e from elevage e where animal='canidé'), (select a from adresse a where code_postale=49320));
insert into eleveur values (3, (select e from elevage e where animal='ovin'), (select a from adresse a where code_postale=36000));
insert into eleveur values (4, (select e from elevage e where animal='ovin'), (select a from adresse a where code_postale=75004));

update eleveur set elevage.animal='porcin' where licence=2;

update eleveur e set adresse.ville='Bordeaux', adresse.code_postale=33000 where (e.elevage).animal='ovin';


create function prohiber() returns trigger as $$
begin
	if(New.adresse).ville='Paris'
	then RAISE NOTICE 'peut pas etre campagnard et parigot';
		return Null;
	else
		return New;
end;
$$ LANGUAGE plpgsql;
		

create trigger aristote BEFORE insert or update on eleveur for each row execute procedure prohiber();


select * from elevage;
select * from adresse;
select * from eleveur;
