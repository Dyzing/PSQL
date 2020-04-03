drop function if exists plus_grand_nb_confondues cascade;

drop function if exists annee_plus_salaries_actionnaires cascade;

drop function if exists pas_plus_de_3 cascade;

drop function if exists liste_actionnaires_tous_salaries cascade;

drop function if exists nb_salaries_jamais_action_2 cascade;

drop function if exists affiche_vente_sup_achat(integer) cascade;

drop function if exists interdire_insertion cascade;

drop function if exists ajout cascade;

-- drop trigger insertion_action cascade;

drop table if exists HISTO_An_ACTIONNAIRE;
drop table if exists ACTION;
drop table if exists SALARIE;
drop table if exists SOCIETE;
drop table if exists PERSONNE;

drop type if exists t_societe_type cascade;
drop type if exists t_personne_type cascade;




create type t_personne_type as (
		NumSecu		int,
		Nom			varchar(30),
		Prenom		varchar(30),
		Sexe		varchar(10),
		DateNaiss	DATE
);


create type t_societe_type as (
		CodeSoc		int,
		NomSoc		varchar(30),
		Adresse		varchar(30)
);


create table PERSONNE of t_personne_type;
create table SOCIETE of t_societe_type;


create table SALARIE (
		PERSONNE 	t_personne_type,
		SOCIETE 	t_societe_type,
		Salaire 	float
);



create table ACTION (
		PERSONNE 	t_personne_type,
		SOCIETE 	t_societe_type,
		dateAct		DATE,
		NbrAct		int,
		typeAct		varchar(30)
);


create table HISTO_An_ACTIONNAIRE (
		PERSONNE 		t_personne_type,
		SOCIETE 		t_societe_type,
		Annee			int,
		NbrActTotal		int,
		Nbr_Achat		int,
		Nbr_vente		int
);




insert into PERSONNE values (1001, 'Nook', 'Tom', 'Male', '2020-01-01');
insert into PERSONNE values (1002, 'Nook', 'Méli', 'Male', '2020-04-01');
insert into PERSONNE values (1003, 'Nook', 'Mélo', 'Male', '2020-04-01');
insert into PERSONNE values (1004, 'Etchebest', 'Philippe', 'Homme', '1966-12-02');
insert into PERSONNE values (1005, 'Hou-Hou', 'Thibou', 'Male', '2005-08-26');


insert into SOCIETE values (1, 'Mairie', 'Niort-en-Mer');
insert into SOCIETE values (2, 'Nook Shop', 'Niort-en-Mer');
insert into SOCIETE values (3, 'Cauchemar en cuisine', 'Bordeaux');

insert into SALARIE values ((select p from PERSONNE p where Prenom='Tom'), (select s from SOCIETE s where NomSoc='Mairie'), 98000);
insert into SALARIE values ((select p from PERSONNE p where Prenom='Méli'), (select s from SOCIETE s where NomSoc='Nook Shop'), 700);
insert into SALARIE values ((select p from PERSONNE p where Prenom='Mélo'), (select s from SOCIETE s where NomSoc='Nook Shop'), 800);
insert into SALARIE values ((select p from PERSONNE p where Prenom='Philippe'), (select s from SOCIETE s where NomSoc='Cauchemar en cuisine'), 8000);
insert into SALARIE values ((select p from PERSONNE p where Prenom='Thibou'), (select s from SOCIETE s where NomSoc='Nook Shop'), 300);



	select * from PERSONNE;
	select * from SOCIETE;
	select * from SALARIE;
	SELECT * FROM ACTION;
	select * from HISTO_An_ACTIONNAIRE;



-- question 3





create function ajout() returns trigger as $$
DECLARE
	temp_NbrActTotal int;
	temp_Nbr_Achat int;
	temp_Nbr_vente int;

	tempT int;
	tempA int;
	tempV int;

BEGIN
--tempT = select NbrActTotal from HISTO_An_ACTIONNAIRE t where ((t.PERSONNE).NumSecu = (New.PERSONNE).NumSecu) and ((t.SOCIETE).CodeSoc = (New.SOCIETE).CodeSoc);
--tempA = select Nbr_Achat from HISTO_An_ACTIONNAIRE a where ((a.PERSONNE).NumSecu = (New.PERSONNE).NumSecu) and ((a.SOCIETE).CodeSoc = (New.SOCIETE).CodeSoc);
--tempV = select Nbr_vente from HISTO_An_ACTIONNAIRE v where ((v.PERSONNE).NumSecu = (New.PERSONNE).NumSecu) and ((v.SOCIETE).CodeSoc = (New.SOCIETE).CodeSoc);
-- bRAISE NOTICE ' NbrActTotal  %', (select NbrActTotal from HISTO_An_ACTIONNAIRE t where ((t.PERSONNE).NumSecu = (New.PERSONNE).NumSecu) and ((t.SOCIETE).CodeSoc = (New.SOCIETE).CodeSoc)  and (SELECT EXTRACT(YEAR FROM New.dateAct) = t.Annee));

if New.typeAct='achat'
then RAISE NOTICE 'action achat comptabilisée de %.', (New.PERSONNE).Prenom;

	IF (select NbrActTotal from HISTO_An_ACTIONNAIRE t where ((t.PERSONNE).NumSecu = (New.PERSONNE).NumSecu) and ((t.SOCIETE).CodeSoc = (New.SOCIETE).CodeSoc) and (SELECT EXTRACT(YEAR FROM New.dateAct) = t.Annee)) IS NULL
	THEN insert into HISTO_An_ACTIONNAIRE values ((select p from PERSONNE p where p.NumSecu = (New.PERSONNE).NumSecu), (select s from SOCIETE s where s.CodeSoc = (New.SOCIETE).CodeSoc), (SELECT EXTRACT(YEAR FROM New.dateAct)), New.NbrAct, New.NbrAct,0);
	ELSE
		temp_NbrActTotal = (select NbrActTotal from HISTO_An_ACTIONNAIRE t where ((t.PERSONNE).NumSecu = (New.PERSONNE).NumSecu) and ((t.SOCIETE).CodeSoc = (New.SOCIETE).CodeSoc)  and (SELECT EXTRACT(YEAR FROM New.dateAct) = t.Annee)) + New.NbrAct ;
		temp_Nbr_Achat = New.NbrAct + (select Nbr_Achat from HISTO_An_ACTIONNAIRE a where ((a.PERSONNE).NumSecu = (New.PERSONNE).NumSecu) and ((a.SOCIETE).CodeSoc = (New.SOCIETE).CodeSoc)  and (SELECT EXTRACT(YEAR FROM New.dateAct) = a.Annee));
		temp_Nbr_vente =  (select Nbr_vente from HISTO_An_ACTIONNAIRE v where ((v.PERSONNE).NumSecu = (New.PERSONNE).NumSecu) and ((v.SOCIETE).CodeSoc = (New.SOCIETE).CodeSoc)  and (SELECT EXTRACT(YEAR FROM New.dateAct) = v.Annee));
		UPDATE HISTO_An_ACTIONNAIRE  SET  
		NbrActTotal  = temp_NbrActTotal, 
		Nbr_Achat = temp_Nbr_Achat,
		Nbr_vente = temp_Nbr_vente 
										WHERE (((PERSONNE).NumSecu = (New.PERSONNE).NumSecu) and ((SOCIETE).CodeSoc = (New.SOCIETE).CodeSoc));
	END IF;
elseif New.typeAct='vente'
then RAISE NOTICE 'action vente comptabilisée de %.', (New.PERSONNE).Prenom;

	IF (select NbrActTotal from HISTO_An_ACTIONNAIRE t where ((t.PERSONNE).NumSecu = (New.PERSONNE).NumSecu) and ((t.SOCIETE).CodeSoc = (New.SOCIETE).CodeSoc) and (SELECT EXTRACT(YEAR FROM New.dateAct) = t.Annee) ) IS NULL
	THEN insert into HISTO_An_ACTIONNAIRE values ((select p from PERSONNE p where p.NumSecu = (New.PERSONNE).NumSecu), (select s from SOCIETE s where s.CodeSoc = (New.SOCIETE).CodeSoc), (SELECT EXTRACT(YEAR FROM New.dateAct)), New.NbrAct, 0,New.NbrAct);
	ELSE
		temp_NbrActTotal = (select NbrActTotal from HISTO_An_ACTIONNAIRE t where ((t.PERSONNE).NumSecu = (New.PERSONNE).NumSecu) and ((t.SOCIETE).CodeSoc = (New.SOCIETE).CodeSoc)  and (SELECT EXTRACT(YEAR FROM New.dateAct) = t.Annee)) + New.NbrAct ;
		temp_Nbr_vente = New.NbrAct + (select Nbr_vente from HISTO_An_ACTIONNAIRE v where ((v.PERSONNE).NumSecu = (New.PERSONNE).NumSecu) and ((v.SOCIETE).CodeSoc = (New.SOCIETE).CodeSoc)  and (SELECT EXTRACT(YEAR FROM New.dateAct) = v.Annee));
		temp_Nbr_Achat =  (select Nbr_Achat from HISTO_An_ACTIONNAIRE a where ((a.PERSONNE).NumSecu = (New.PERSONNE).NumSecu) and ((a.SOCIETE).CodeSoc = (New.SOCIETE).CodeSoc)  and (SELECT EXTRACT(YEAR FROM New.dateAct) = a.Annee));
		UPDATE HISTO_An_ACTIONNAIRE  SET  
		NbrActTotal  = temp_NbrActTotal, 
		Nbr_Achat = temp_Nbr_Achat,
		Nbr_vente = temp_Nbr_vente 
										WHERE (((PERSONNE).NumSecu = (New.PERSONNE).NumSecu) and ((SOCIETE).CodeSoc = (New.SOCIETE).CodeSoc)  and (SELECT EXTRACT(YEAR FROM New.dateAct) = 	Annee));
	END IF;
else
	RAISE NOTICE 'action non comptabilisée. Veuillez réessayer avec achat ou vente.';
END IF;
-- RAISE NOTICE 'temp_NbrActTotal %, temp_Nbr_Achat %, temp_Nbr_vente %',temp_NbrActTotal, temp_Nbr_Achat, temp_Nbr_vente ;
return NEW;
END;
$$ LANGUAGE plpgsql;




create trigger insertion_action
		AFTER INSERT 
ON ACTION
FOR EACH ROW execute procedure ajout();





-- question 4





CREATE FUNCTION interdire_insertion() RETURNS TRIGGER AS $$
 
BEGIN
IF current_date > New.dateAct 
THEN
		RAISE NOTICE 'current_date :  %, date insérée :  %', current_date, New.dateAct;
		RAISE EXCEPTION 'Action en dessous de la date --> action non comptabilisée de %.', (New.PERSONNE).Prenom;
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;


create trigger interdire_insertion_trigger 
		BEFORE INSERT or UPDATE
ON ACTION
FOR EACH ROW execute procedure interdire_insertion();



-- question 5


create function affiche_vente_sup_achat(corp int) RETURNS TABLE(Annee int) AS $$ 
BEGIN
	RETURN QUERY SELECT h.Annee from HISTO_An_ACTIONNAIRE h WHERE ( (corp = (h.SOCIETE).CodeSoc) and (h.Nbr_vente >= h.Nbr_Achat) );
END;
$$ LANGUAGE 'plpgsql';




-- question 6




create function nb_salaries_jamais_action_2() RETURNS int AS $$ 
DECLARE 
result int;
BEGIN
	result := (SELECT COUNT(s.PERSONNE) from HISTO_An_ACTIONNAIRE h FULL JOIN SALARIE s on h.PERSONNE = s.PERSONNE where (NbrActTotal is NULL));
	return result;
END;
$$ LANGUAGE 'plpgsql';




-- question 7


create function liste_actionnaires_tous_salaries() RETURNS TABLE(nomSoc varchar(30), Annee int) AS $$ 
BEGIN
	RETURN QUERY (SELECT DISTINCT societe_actionnee1, annee1 from 
(		(SELECT DISTINCT (h.SOCIETE).NomSoc as societe_actionnee1, h.Annee as annee1, COUNT(h.PERSONNE) as compteur1  from 
			HISTO_An_ACTIONNAIRE h INNER JOIN SALARIE s on (h.PERSONNE = s.PERSONNE)  GROUP BY (h.SOCIETE, h.Annee)		) as t1
INNER JOIN 
		(SELECT DISTINCT (h.SOCIETE).NomSoc as societe_actionnee2, h.annee as annee2, COUNT(h.PERSONNE) as compteur2  
			from HISTO_An_ACTIONNAIRE h INNER JOIN SALARIE s on (h.SOCIETE = s.SOCIETE and h.PERSONNE = s.PERSONNE) GROUP BY (h.SOCIETE, h.Annee)	) as t2 
on t1.societe_actionnee1 = t2.societe_actionnee2 and t1.Annee1 = t2.Annee2 and t1.compteur1 = t2.compteur2	) as t3);
END;
$$ LANGUAGE 'plpgsql';






-- question 8


CREATE
	FUNCTION annee_plus_salaries_actionnaires(CodeSoc int) 
		RETURNS	int
			AS
		$$
		
			DECLARE curseur CURSOR FOR
					SELECT Annee FROM (select DISTINCT * from HISTO_An_ACTIONNAIRE h natural join SALARIE s where  (h.SOCIETE).CodeSoc = CodeSoc   ORDER BY Annee) as t1;
					nb_salaries_dans_annee_max int;
					nb_salaries_dans_annee_courant int;
					annee_max int;
			BEGIN	
					nb_salaries_dans_annee_max = 0;
					annee_max = 0;
					FOR i IN curseur
					LOOP
						nb_salaries_dans_annee_courant := (SELECT COUNT(Annee) FROM (select DISTINCT * from HISTO_An_ACTIONNAIRE h natural join SALARIE s where  (h.SOCIETE).CodeSoc = CodeSoc   ORDER BY Annee) as t1 WHERE Annee = i.Annee);
						IF nb_salaries_dans_annee_courant > nb_salaries_dans_annee_max
						THEN
							nb_salaries_dans_annee_max := nb_salaries_dans_annee_courant;
							annee_max := i.Annee;
						END IF;
					END LOOP;
			
					return annee_max;	
			END;		
		
		$$ LANGUAGE plpgsql;





-- question 9

 
create function plus_grand_nb_confondues(annee_arg int) RETURNS TABLE(individu t_personne_type, somme_actions bigint) AS $$ 
BEGIN
	RETURN QUERY (SELECT *  FROM (SELECT h.PERSONNE, SUM(h.NbrActTotal) as oh  from HISTO_An_ACTIONNAIRE h WHERE (h.Annee = 2020) GROUP BY h.PERSONNE) as t2 where oh = (SELECT MAX(oh) FROM  (SELECT SUM(h.NbrActTotal) as oh from HISTO_An_ACTIONNAIRE h WHERE (h.Annee = 2020) GROUP BY h.PERSONNE) as t3));
END;
$$ LANGUAGE 'plpgsql';






-- question 10



CREATE FUNCTION pas_plus_de_3() RETURNS TRIGGER AS $$
DECLARE
temp_nb_actions_dans_annee	int;
temp_annee_new int;
BEGIN
temp_annee_new := (SELECT EXTRACT(YEAR FROM New.dateAct));
temp_nb_actions_dans_annee := (select COUNT(a.dateAct) FROM ACTION a WHERE ( ((New.PERSONNE).NumSecu = (a.PERSONNE).NumSecu) and (SELECT EXTRACT(YEAR FROM a.dateAct) = temp_annee_new) ) );
IF  temp_nb_actions_dans_annee >= 3
THEN
		RAISE EXCEPTION 'Il y a au moins trois actions de réalisées dans cette annee. Action non comptabilisée de %.', (New.PERSONNE).Prenom;
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;


create trigger pas_plus_de_3_trigger 
		BEFORE INSERT
ON ACTION
FOR EACH ROW execute procedure pas_plus_de_3();





-- INSERTIONS

-- Tom Nook

 insert into ACTION values ((select p from PERSONNE p where Prenom='Tom'), (select s from SOCIETE s where NomSoc='Mairie'), '2024-05-01', 3, 'achat');
 insert into ACTION values ((select p from PERSONNE p where Prenom='Tom'), (select s from SOCIETE s where NomSoc='Mairie'), '2020-05-01', 2, 'vente');
 insert into ACTION values ((select p from PERSONNE p where Prenom='Tom'), (select s from SOCIETE s where NomSoc='Cauchemar en cuisine'), '2022-05-01', 1, 'achat');
 insert into ACTION values ((select p from PERSONNE p where Prenom='Tom'), (select s from SOCIETE s where NomSoc='Nook Shop'), '2020-05-01', 2, 'vente');

 insert into ACTION values ((select p from PERSONNE p where Prenom='Tom'), (select s from SOCIETE s where NomSoc='Mairie'), '2020-05-01', 10, 'vente');



-- Méli

 insert into ACTION values ((select p from PERSONNE p where Prenom='Méli'), (select s from SOCIETE s where NomSoc='Nook Shop'), '2020-05-01', 8, 'achat');
 insert into ACTION values ((select p from PERSONNE p where Prenom='Méli'), (select s from SOCIETE s where NomSoc='Nook Shop'), '2020-05-01', 2, 'vente');
 insert into ACTION values ((select p from PERSONNE p where Prenom='Méli'), (select s from SOCIETE s where NomSoc='Mairie'), '2024-05-05', 5, 'vente');
 insert into ACTION values ((select p from PERSONNE p where Prenom='Méli'), (select s from SOCIETE s where NomSoc='Mairie'), '2024-05-05', 5, 'achat');

 insert into ACTION values ((select p from PERSONNE p where Prenom='Méli'), (select s from SOCIETE s where NomSoc='Nook Shop'), '2020-05-01', 4, 'achat');
 insert into ACTION values ((select p from PERSONNE p where Prenom='Méli'), (select s from SOCIETE s where NomSoc='Nook Shop'), '2020-05-01', 4, 'vente');

 insert into ACTION values ((select p from PERSONNE p where Prenom='Méli'), (select s from SOCIETE s where NomSoc='Nook Shop'), '2021-05-01', 4, 'achat');
 insert into ACTION values ((select p from PERSONNE p where Prenom='Méli'), (select s from SOCIETE s where NomSoc='Nook Shop'), '2021-05-01', 4, 'vente');


-- Mélo

 insert into ACTION values ((select p from PERSONNE p where Prenom='Mélo'), (select s from SOCIETE s where NomSoc='Nook Shop'), '2020-05-01', 2, 'achat');
 insert into ACTION values ((select p from PERSONNE p where Prenom='Mélo'), (select s from SOCIETE s where NomSoc='Nook Shop'), '2019-02-01', 2, 'achat');
 insert into ACTION values ((select p from PERSONNE p where Prenom='Mélo'), (select s from SOCIETE s where NomSoc='Mairie'), '2022-05-05', 6, 'vente');
 insert into ACTION values ((select p from PERSONNE p where Prenom='Mélo'), (select s from SOCIETE s where NomSoc='Mairie'), '2022-05-05', 3, 'achat');

 insert into ACTION values ((select p from PERSONNE p where Prenom='Mélo'), (select s from SOCIETE s where NomSoc='Nook Shop'), '2021-09-08', 3, 'vente');

-- Thibou

 insert into ACTION values ((select p from PERSONNE p where Prenom='Thibou'), (select s from SOCIETE s where NomSoc='Nook Shop'), '2021-09-08', 5, 'vente');
 insert into ACTION values ((select p from PERSONNE p where Prenom='Thibou'), (select s from SOCIETE s where NomSoc='Nook Shop'), '2021-12-08', 1, 'achat');


UPDATE ACTION a set dateAct = '2019-09-17' where (a.PERSONNE).Prenom = 'Mélo';


-- test


	select * from PERSONNE;
	select * from SOCIETE;
	select * from SALARIE;
	select * from ACTION;
	select * from HISTO_An_ACTIONNAIRE;

select affiche_vente_sup_achat(1);

select nb_salaries_jamais_action_2();

select liste_actionnaires_tous_salaries();

select annee_plus_salaries_actionnaires(2);

select plus_grand_nb_confondues(2020);




