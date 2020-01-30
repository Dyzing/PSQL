drop table if exists STAT_RESULTAT;
drop table if exists TabNOTE;
drop table if exists MATIERE;
drop table if exists FORMATION;
drop table if exists ENSEIGNANT;
drop table if exists ETUDIANT;
drop function if exists moyNote();

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


CREATE
	FUNCTION moyNote() 
		RETURNS	float
			AS
		$$
		
			DECLARE curseur CURSOR FOR
					SELECT Nommat, nomForm, coef, Nom FROM MATIERE NATURAL JOIN TabNOTE NATURAL JOIN ETUDIANT;
			BEGIN	
					FOR i IN curseur
					LOOP
						RAISE NOTICE 'la nom est de : %', i.Nom;
						
					END LOOP;
			END;		
		
		$$ LANGUAGE plpgsql;
		
	 
SELECT moyNote();























