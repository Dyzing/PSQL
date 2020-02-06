drop table if exists STAT_RESULTAT;
drop table if exists TabNOTE;
drop table if exists MATIERE;
drop table if exists FORMATION;
drop table if exists ENSEIGNANT;
drop table if exists ETUDIANT;
drop function if exists moyNote();
drop function if exists Moy_format();
drop function if exists moy_eleve(v_nomform varchar(30));

create table ETUDIANT (
	NumEt	int,
	Nom		VARCHAR(30),
	Prenom	VARCHAR(30),
	PRIMARY KEY (NumEt)
);

create table ENSEIGNANT (
	NumEns		int,
	NomEns		VARCHAR(30),
	PrenomEns	VARCHAR(30),
	PRIMARY KEY (NumEns)
);

create table FORMATION (
	nomForm				VARCHAR(30),
	nbretud				int,
	Enseigresponsable	VARCHAR(30),
	PRIMARY KEY (nomForm)
);

create table MATIERE (
	Nommat	VARCHAR(30),
	nomForm	VARCHAR(30),
	Numens	int,
	coef	float,
	PRIMARY KEY (Nommat),
	FOREIGN KEY (nomForm) references FORMATION(nomForm)
);

create table TabNOTE (
	Num_Etud	int,
	Nommat		VARCHAR(30),
	nomForm		VARCHAR(30),
	Note		float,
	FOREIGN KEY (Num_Etud) references ETUDIANT(NumEt),
	FOREIGN KEY (Nommat) references MATIERE(Nommat),
	FOREIGN KEY (nomForm) references FORMATION(nomForm)
);

create table STAT_RESULTAT (
	Nom_Formation	VARCHAR(30),
	moy_generale	float,
	nbrRecu			int,
	nbrEtdPres		int,
	NoteMAx			float,
	NoteMin			float
);




insert into ETUDIANT values (10, 'DEROZAN', 'DeMar');
insert into ETUDIANT values (2, 'BRYANT', 'GiGi');
insert into ETUDIANT values (1, 'BOOKER', 'Devin');
insert into ETUDIANT values (34, 'ANTETOKOUNMPO', 'Giannis');

insert into ENSEIGNANT values (8024, 'BRYANT', 'Kobe');

insert into FORMATION values ('NBA', 30, 'Kobe BRYANT');
insert into FORMATION values ('WNBA', 30, 'Kobe BRYANT');

insert into MATIERE values ('Man Regular Season', 'NBA', 8024, 23);
insert into MATIERE values ('Man Playoffs', 'NBA', 8024, 81);
insert into MATIERE values ('Woman Regular Season', 'WNBA', 8024, 23);
insert into MATIERE values ('Woman Playoffs', 'WNBA', 8024, 81);

insert into TabNOTE values (10, 'Man Regular Season', 'NBA', 20.0);
insert into TabNOTE values (10, 'Man Playoffs', 'NBA', 21.9);
insert into TabNOTE values (2, 'Woman Regular Season', 'WNBA', 20.0);
insert into TabNOTE values (2, 'Woman Playoffs', 'WNBA', 0.0);
insert into TabNOTE values (1, 'Man Regular Season', 'NBA', 22.2);
insert into TabNOTE values (1, 'Man Playoffs', 'NBA', 0);
insert into TabNOTE values (34, 'Man Regular Season', 'NBA', 19.8);
insert into TabNOTE values (34, 'Man Playoffs', 'NBA', 23.0);


/*insert into STAT_RESULTAT values ('NBA', 25.0, 5, 1, 35.4, 7.6); */



select * from etudiant;
select * from enseignant;
select * from formation;
select * from matiere;
select * from tabnote;
select * from stat_resultat;

--2--

CREATE
	FUNCTION moyNote() 
		RETURNS	float
			AS
		$$
		
			DECLARE curseur CURSOR FOR
					SELECT Nommat, Note, coef FROM MATIERE NATURAL JOIN TabNOTE NATURAL JOIN ETUDIANT;
					v_numerateur TabNOTE.Note %TYPE;
					v_denominateur TabNOTE.Note %TYPE;
					v_notemoy TabNOTE.Note %TYPE;
			BEGIN	
					v_numerateur = 0;
					v_denominateur = 0;
					v_notemoy = 0;
					FOR i IN curseur
					LOOP
						v_numerateur := (i.Note * i.coef) + v_numerateur;
						v_denominateur := i.coef + v_denominateur;					
					END LOOP;
					v_notemoy = v_numerateur / v_denominateur;
					RAISE NOTICE 'la moyenne des étudiants est de : %', v_notemoy;				
					return v_notemoy;	
			END;		
		
		$$ LANGUAGE plpgsql;
		
	 
SELECT moyNote();



--3--

SELECT e.nom, e.prenom, e.numet, t.num_etud, t.note FROM ETUDIANT e JOIN TabNOTE t ON e.numet = t.num_etud WHERE t.Note > moyNote();


--4--

CREATE
	FUNCTION Moy_format(v_nomform varchar(30))
		RETURNS float
			AS
		$$
			
			DECLARE curseur CURSOR FOR
					SELECT t.Note, t.nomform, t.Nommat, m.coef FROM TabNOTE t NATURAL JOIN MATIERE m WHERE v_nomform = t.nomForm;
					v_numerateur TabNOTE.Note %TYPE;
					v_denominateur TabNOTE.Note %TYPE;
					v_notemoy TabNOTE.Note %TYPE;				
			BEGIN
					v_numerateur = 0;
					v_denominateur = 0;
					v_notemoy = 0;
					
					FOR i IN curseur
					LOOP
						v_numerateur := (i.Note * i.coef) + v_numerateur;
						v_denominateur := (i.coef) + v_denominateur;
					END LOOP;
					v_notemoy = v_numerateur / v_denominateur;	
					RAISE NOTICE 'la moyenne de la formation % est de : %', v_nomform, v_notemoy;	
					return v_notemoy;	
			END;
		
		$$ LANGUAGE plpgsql;

SELECT Moy_format('NBA');
SELECT Moy_format('WNBA');


--5--

CREATE
	FUNCTION moy_eleve(v_nomform varchar(30))
		RETURNS int
			AS
		$$
			
			DECLARE curseur CURSOR FOR
					SELECT t.Note, t.nomform, t.Nommat, coef, numet, nom, prenom FROM TabNOTE t NATURAL JOIN MATIERE  NATURAL JOIN ETUDIANT  WHERE v_nomform = t.nomForm;
					v_numerateur TabNOTE.Note %TYPE;
					v_denominateur TabNOTE.Note %TYPE;
					v_notemoy TabNOTE.Note %TYPE;
					v_nbrRecu STAT_RESULTAT.nbrRecu %TYPE;				
			BEGIN
					v_numerateur = 0;
					v_denominateur = 0;
					v_notemoy = 0;
					v_nbrRecu = 0;
					FOR i IN curseur
					LOOP
						v_numerateur := (i.Note * i.coef) + v_numerateur;
						v_denominateur := (i.coef) + v_denominateur;
						v_notemoy = v_numerateur / v_denominateur;	
						IF(v_notemoy >= 10)
							THEN v_nbrRecu := v_nbrRecu +1;
						END IF;
					RAISE NOTICE 'moyenne de % % est de %', nom, prenom, v_notemoy;			
					END LOOP;
					RAISE NOTICE 'le nombre de reçu est de : %', v_nbrRecu;												
					return v_nbrRecu;	
			END;
		
		$$ LANGUAGE plpgsql;
			

SELECT moy_eleve('NBA');












