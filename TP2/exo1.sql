
drop table PRODUIT1;
drop table PRODUIT2;

/*
CREATE TABLE PRODUIT2
(
    NumProd int,
    Designation VARCHAR(30),
    Prix int
);

CREATE TABLE PRODUIT1
(
    NumProd int,
    Designation VARCHAR(30),
    Prix int
);

INSERT INTO PRODUIT1 (NumProd, Designation, Prix) VALUES
(0001, 'chaise', 21),
(0002, 'table', 60),
(0003, 'escalier', 200),
(0004, 'rideau', 14),
(0005, 'tapis', NULL);



SELECT * FROM PRODUIT1;

--SELECT NumProd, UPPER(Designation) as Designation_upper, Prix FROM PRODUIT1;



DROP FUNCTION insertion_p2();
CREATE FUNCTION insertion_p2() RETURNS void AS 
$$

DECLARE 
	curs1 CURSOR for SELECT NumProd, Designation, Prix FROM PRODUIT1;
	v_numprod PRODUIT1.NumProd %TYPE;
	v_designation PRODUIT1.Designation %TYPE;
	v_prix PRODUIT1.Prix %TYPE;
BEGIN

IF (NOT Exists(SELECT * FROM PRODUIT1)) THEN
			INSERT INTO PRODUIT2 (NumProd, Designation, Prix) VALUES
			(0, UPPER('Pas de produit'), NULL);
ELSE
	OPEN curs1;
	LOOP
		FETCH curs1 INTO v_numprod, v_designation, v_prix;
		EXIT WHEN NOT FOUND;		  
		
		IF v_prix IS NULL THEN
			INSERT INTO PRODUIT2 (NumProd, Designation, Prix) VALUES
			(v_numprod, UPPER(v_designation), 0);
		ELSE
			INSERT INTO PRODUIT2 (NumProd, Designation, Prix) VALUES
			(v_numprod, UPPER(v_designation), v_prix / 7);			
		END IF;
	END LOOP;
	CLOSE curs1;
END IF;

END;
$$ LANGUAGE 'plpgsql';

SELECT insertion_p2();

SELECT * FROM PRODUIT2;

*/
drop table VOL;
drop table PILOTE;
drop table AVION;


CREATE TABLE AVION
(
    AvNum int,
    AvNom VARCHAR(30),
    Capacite int,
    Localisation VARCHAR(30)
);

CREATE TABLE PILOTE
(
    PiNum int,
    PiNom VARCHAR(30),
    PiPrenom VARCHAR(30),
    Ville VARCHAR(30),
    Salaire int
);

CREATE TABLE VOL
(
    VolNum VARCHAR(30),
    PiNum int,
    AvNum int,
    VilleDep VARCHAR(30),
    VilleArr VARCHAR(30),
    HeureDep int,
    HeureArr int
);
		 
INSERT INTO AVION (AvNum, AvNom, Capacite, Localisation) VALUES
(0001, 'Requin', 2, 'Orléans'),
(0002, 'Phoenix', 1, 'Japon'),
(0003, 'Bonnasse', 200, 'CDG'),
(0004, 'Ecureuil', 6, 'Angers');



INSERT INTO PILOTE (PiNum, pinom, piprenom, ville, salaire) VALUES
(1, 'MAIGNAN', 'Quentin', 'Trélazé', 15),
(2, 'TREM', 'Guillaume', 'Paris', 12000),
(3, 'LAFARGUE', 'Christophe', 'Angers', 2000);



INSERT INTO VOL (VolNum, PiNum, AvNum, VilleDep, VilleArr, HeureDep, HeureArr) VALUES
('TG931', 1, 0001, 'Angers', 'Paris', 8, 12),
('AF333', 2, 0002, 'Paris', 'San Fransisco', 6, 16),
('LHOOQ', 3, 0003, 'Toulouse', 'Alger', 9, 17),
('LAPT', 1, 0001, 'Nantes', 'Angers', 15, 21);

SELECT * FROM AVION;
SELECT * FROM PILOTE;
SELECT * FROM VOL;
