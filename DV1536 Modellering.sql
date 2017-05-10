DROP TABLE Artikellista;
DROP TABLE Ordrar;
DROP TABLE Kladesplagg;
DROP TABLE Anvandare;
DROP TABLE Rabatt;
DROP TABLE Kund;

CREATE TABLE Kund
(
	Kundnummer BIGINT IDENTITY (1, 1) PRIMARY KEY,
	Fornamn VARCHAR(100),
	Efternamn VARCHAR(100),
	Personnummer BIGINT,
	Mobilnummer BIGINT,
	Kon VARCHAR(100),
	Gatuadress VARCHAR(100),
	Postadress VARCHAR(100)
);

CREATE TABLE Rabatt
(
	Rabattnummer INT IDENTITY (1, 1) PRIMARY KEY, --Flera rabatter kan �ver tid kan ha samma namn.
	Rabattkod VARCHAR(100),
	Startdatum BIGINT,
	Slutdatum BIGINT,
	Storlek INT --Rabattens storlek i procent.
);

CREATE TABLE Anvandare
(
	Anvandarnamn VARCHAR(100) PRIMARY KEY,
	Losenord VARCHAR(100),
	Typ VARCHAR(100) CHECK (Typ IN ('Kund', 'Ink�pare', 'Ledning')),
	Epost VARCHAR(100),
	Kundnummer BIGINT,
	--^L�nkar en kundanv�ndare till dess attribut som kund.
	CONSTRAINT FK_Anvandare_Kundnummer FOREIGN KEY (Kundnummer)
    REFERENCES Kund (Kundnummer)
);

CREATE TABLE Ordrar
(
	Kundnummer BIGINT FOREIGN KEY REFERENCES Kund (Kundnummer),
	Ordernummer BIGINT IDENTITY (1, 1) PRIMARY KEY,
	Totalsumma FLOAT,
	Leveransadress VARCHAR(100),
	Totalvikt INT,
	Datum BIGINT,
	Fraktkostnad INT,
	Rabattkod VARCHAR(100),
	Rabattnummer INT,
	--^Ges av rabattkoden om den finns och �r giltig.
	--Finns tv� rabatter med samma namn tas den som �r giltig.
	Totalkostnad FLOAT,
	CONSTRAINT FK_Ordrar_Rabattnummer FOREIGN KEY (Rabattnummer)
    REFERENCES Rabatt (Rabattnummer)
);

CREATE TABLE Kladesplagg
(
	Artikelnummer BIGINT IDENTITY (1, 1) PRIMARY KEY,
	Modellnamn VARCHAR(100),
	Tillverkare VARCHAR(100),
	Tillverkningsland VARCHAR(100),
	Vikt FLOAT, --Gram
	Storlek VARCHAR(100) CHECK (Storlek IN 
	(
	'XS','S','M','L','XL','XXL'
	)),
	Forsaljningspris FLOAT,
	Inkopspris FLOAT,
	Farg VARCHAR(100),
	Lagersaldo INT,
	Kategori VARCHAR(100) CHECK (Kategori IN 
	(
	'Byxor','Tr�ja','Jacka',
	'Underkl�der','Kl�nning','V�ska'
	)),
	Typ varchar(100) CHECK (Typ IN 
	(
	'Shorts','Jeans','Tr�ningsbyxor',
	'T-shirt','Sweatshirt','Cardigan',
	'Linne','Vinterjacka','Skinnjacka',
	'�vrig jacka','Trosor','BH',
	'Nattlinne','L�ngkl�nning','Kort kl�nning',
	'Skinnv�ska','Ryggs�ck','Y-front',
	'Boxershort','Kostym'
	)),
	Kon VARCHAR(10) CHECK (Kon IN ('Herr','Dam')),
	AntalSalda INT 
);

CREATE TABLE Artikellista
(
	Ordernummer BIGINT,
	Artikelnummer BIGINT,
	Antal INT
	--CONSTRAINT FK_Artikellista_Ordernummer FOREIGN KEY (Ordernummer)
	--REFERENCES Ordrar (Ordernummer),
	--CONSTRAINT FK_Artikellista_Artikelnummer FOREIGN KEY (Artikelnummer)
	--REFERENCES Kladesplagg (Artikelnummer)
);

GO
CREATE TRIGGER TR_GET_VALUES ON Ordrar 
	AFTER INSERT 
AS
BEGIN
	DECLARE @Totalsumma FLOAT = (SELECT SUM(Kladesplagg.Forsaljningspris * Artikellista.Antal) FROM Kladesplagg 
		INNER JOIN Artikellista ON Artikellista.Artikelnummer = Kladesplagg.Artikelnummer
		INNER JOIN Ordrar ON Ordrar.Ordernummer = Artikellista.Ordernummer 
		WHERE Ordrar.Ordernummer = (SELECT Ordernummer FROM INSERTED)); 
	
	DECLARE @Totalvikt FLOAT = (SELECT SUM(Kladesplagg.Vikt * Artikellista.Antal) FROM Kladesplagg 
		INNER JOIN Artikellista ON Artikellista.Artikelnummer = Kladesplagg.Artikelnummer
		INNER JOIN Ordrar ON Ordrar.Ordernummer = Artikellista.Ordernummer
		WHERE Ordrar.Ordernummer = (SELECT Ordernummer FROM inserted)); 
	
	DECLARE @Frakt INT = 50; 
		IF @Totalvikt >= 1000 
			SET @Frakt = ((ROUND((@Totalvikt/1000), 0) * 20) + 50); 
 
	DECLARE @Totalkostnad FLOAT = (@Totalsumma + @Frakt);  	
 
	
	UPDATE Ordrar SET 
	Totalsumma = @Totalsumma, 
	Totalvikt = @Totalvikt, 
	Fraktkostnad = @Frakt, 
	Totalkostnad = @Totalkostnad
	WHERE (SELECT Ordernummer FROM inserted) = Ordernummer
	END;
GO



INSERT INTO Kladesplagg
(
Modellnamn, Tillverkare, 
Tillverkningsland, Vikt, Storlek, 
Forsaljningspris, Inkopspris, Farg, 
Lagersaldo, Kategori, Typ, Kon, AntalSalda
) 
VALUES
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Bl�', 25, 'Byxor', 'Shorts', 'Dam', 20),
('Sture', 'Gucci', 'Italien', 250.0, 'M', 2499.90, 1999.90, 'Bl�', 15, 'Byxor', 'Shorts', 'Dam', 15),
('Sture', 'Gucci', 'Italien', 250.0, 'XS', 2499.90, 1999.90, 'Bl�', 25, 'Byxor', 'Shorts', 'Dam', 32),
('Dope', 'Adidas', 'Tyskland', 200.0, 'M', 299.90, 199.90, 'Svart', 50, 'Kl�nning', 'L�ngkl�nning', 'Herr', 76),
('Dope', 'Adidas', 'Tyskland', 200.0, 'S', 299.90, 199.90, 'Svart', 50, 'Kl�nning', 'L�ngkl�nning', 'Herr', 54),
('Dope', 'Adidas', 'Tyskland', 200.0, 'L', 299.90, 199.90, 'Svart', 50, 'Kl�nning', 'L�ngkl�nning', 'Herr', 90),
('Foppa', 'Crocc', 'Polen', 100.0, 'L', 5000, 30, 'Gr�n', 100, 'Tr�ja', 'Linne', 'Herr', 112),
('Foppa', 'Crocc', 'Polen', 100.0, 'L', 5000, 30, 'R�d', 100, 'Tr�ja', 'Linne', 'Dam', 87),
('Sopa', 'Rydbergs', 'Sverige', 300.0, 'S', 399.90, 199.90, 'Svart', 5, 'V�ska', 'Ryggs�ck', 'Dam', 1),
('Sopa', 'Rydbergs', 'Sverige', 300.0, 'S', 399.90, 199.90, 'Bl�', 5, 'V�ska', 'Ryggs�ck', 'Dam', 3),
('Sopa', 'Rydbergs', 'Sverige', 300.0, 'S', 399.90, 199.90, 'Vit', 5, 'V�ska', 'Ryggs�ck', 'Dam', 270);

INSERT INTO Kund
(
Fornamn, Efternamn, Personnummer,
Mobilnummer, Kon, Gatuadress, Postadress
)
VALUES
('Anders', 'Nelsson', 7906010995, 0709820012, 'Man', 'Stadsv�gen 12 B', '371 38 Karlskrona'),
('Markus', 'Persson', 9109096754, 0735406732, 'Man', 'Gatugatan 19', '871 40 H�rn�sand'),
('Ulrika', 'Andersson', 5604289812, 0728903892, 'Kvinna', 'V�gv�gen 1', '112 10 Mellerud'),
('Gunilla', 'Nachtmann', 7304079823, 0765740290, 'Kvinna', 'K�pmangatan 56', '411 40 Stockholm');

INSERT INTO Rabatt
(
Rabattkod, Startdatum, 
Slutdatum, Storlek
)
VALUES
('P�SK', 20170315, 20170415, 50),
('MELLANDAGAR', 20171225, 20180130, 20),
('SOMMAR', 20170601, 20170901, 10);

INSERT INTO Anvandare
(
Anvandarnamn, Losenord,
Typ, Epost, Kundnummer
)
VALUES
('Big Boss', 'password', 'Ledning', 'mats_karlsson@bestwebshop.com', NULL),
('Anders79', 'catlover', 'Kund', 'anders_nelsson@hotmail.com', 1),
('Markus91', 'shopaholic123', 'Kund', 'markus.persson@gmail.com', 2),
('UllaA', 'ulrikasl�senord', 'Kund', 'ulrikaandersson@outlook.com', 3),
('GunillaNachtmann', 'fantasintarslut', 'Kund', 'nachtmann1973@yahoo.com', 4),
('Lagerfyllaren', 'lagerislife', 'Ink�pare', 'niklas_k�pman@bestwebshop.com', NULL);

INSERT INTO Artikellista 
(Ordernummer, Artikelnummer, Antal) 
VALUES
(1, 7, 3),
(1, 8, 20),
(2, 10, 1),
(3, 1, 10),
(4, 3, 10), 
(4, 8, 20);

INSERT INTO Ordrar VALUES ( 1, NULL, 'Stadsv�gen 12 B 371 38 Karlskrona', NULL, 20170510, NULL, 'P�SK', NULL, NULL)
INSERT INTO Ordrar VALUES ( 2, NULL, 'Gatugatan 19 871 40 H�rn�sand', NULL, 20160905, NULL, 'KORV', NULL, NULL)
INSERT INTO Ordrar VALUES ( 1, NULL, 'Stadsv�gen 12 B 371 38 Karlskrona', NULL, 20170509, NULL, 'P�SK', NULL, NULL) 
INSERT INTO Ordrar VALUES ( 3, NULL, 'V�gv�gen 1 112 10 Mellerud', NULL, 20170510, NULL, 'P�SK', NULL, NULL)


DROP VIEW BestsellersWomen		--F�r kunder
DROP VIEW BestsellersMen		--F�r kunder
DROP VIEW ClothesUnder500		--F�r ink�pare
DROP VIEW LowStock				--F�r ink�pare
DROP PROCEDURE sp_MellanDagsRea --F�r ink�pare
DROP VIEW ProfitMargin			--F�r ledning
DROP VIEW Bestsellers			--F�r ledning

GO --GO innan och efter varje CREATE VIEW/PROCEDURE f�r att de m�ste vara ensamma i en batch.
CREATE VIEW BestsellersWomen AS SELECT TOP 10 * FROM Kladesplagg 
WHERE Kon = 'Dam' ORDER BY AntalSalda ASC
GO
CREATE VIEW BestsellersMen AS SELECT TOP 10 * FROM Kladesplagg 
WHERE Kon = 'Herr' ORDER BY AntalSalda ASC
GO
CREATE VIEW ClothesUnder500 AS SELECT * FROM Kladesplagg 
WHERE Forsaljningspris < 500 ORDER BY Forsaljningspris OFFSET 0 ROWS
GO
CREATE VIEW LowStock AS SELECT * FROM Kladesplagg WHERE Lagersaldo < 5
GO
CREATE PROCEDURE sp_MellanDagsRea AS
BEGIN
	UPDATE Kladesplagg SET Forsaljningspris = Forsaljningspris * 0.8
END;
GO
CREATE VIEW ProfitMargin AS SELECT Artikelnummer, Modellnamn, Forsaljningspris - Inkopspris AS 'Vinstmarginal' 
FROM Kladesplagg ORDER BY Forsaljningspris - Inkopspris DESC OFFSET 0 ROWS
GO
CREATE VIEW Bestsellers AS SELECT AntalSalda AS 'Antal s�lda', Artikelnummer, Modellnamn, Forsaljningspris - Inkopspris AS 'Vinstmarginal'
FROM Kladesplagg ORDER BY AntalSalda DESC OFFSET 0 ROWS
GO
SELECT * FROM ORDRAR
