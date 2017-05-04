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
	Rabattnummer INT IDENTITY (1, 1) PRIMARY KEY, --Flera rabatter kan över tid kan ha samma namn.
	Rabattkod VARCHAR(100),
	Startdatum BIGINT,
	Slutdatum BIGINT,
	Storlek VARCHAR(10) --Rabattens storlek i procent.
);

CREATE TABLE Anvandare
(
	Anvandarnamn VARCHAR(100) PRIMARY KEY,
	Losenord VARCHAR(100),
	Typ VARCHAR(100) CHECK (Typ IN ('Kund', 'Inköpare', 'Ledning')),
	Epost VARCHAR(100),
	Kundnummer BIGINT,
	--^Länkar en kundanvändare till dess attribut som kund.
	CONSTRAINT FK_Anvandare_Kundnummer FOREIGN KEY (Kundnummer)
    REFERENCES Kund (Kundnummer)
);

CREATE TABLE Ordrar
(
	Kundnummer BIGINT,
	Ordernummer BIGINT IDENTITY (1, 1) PRIMARY KEY,
	Totalsumma INT,
	Leveransadress VARCHAR(100),
	Totalvikt INT,
	Datum BIGINT,
	Fraktkostnad INT,
	Rabattkod VARCHAR(100),
	Rabattnummer INT,
	--^Ges av rabattkoden om den finns och är giltig.
	--Finns två rabatter med samma namn tas den som är giltig.
	Totalkostnad INT,
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
	'Byxor','Tröja','Jacka',
	'Underkläder','Klänning','Väska'
	)),
	Typ varchar(100) CHECK (Typ IN 
	(
	'Shorts','Jeans','Träningsbyxor',
	'T-shirt','Sweatshirt','Cardigan',
	'Linne','Vinterjacka','Skinnjacka',
	'Övrig jacka','Trosor','BH',
	'Nattlinne','Långklänning','Kort klänning',
	'Skinnväska','Ryggsäck','Y-front',
	'Boxershort','Kostym'
	)),
	Kon VARCHAR(10) CHECK (Kon IN ('Herr','Dam'))
);

CREATE TABLE Artikellista
(
	Ordernummer BIGINT,
	Artikelnummer BIGINT,
	Antal INT
	CONSTRAINT FK_Artikellista_Ordernummer FOREIGN KEY (Ordernummer)
    REFERENCES Ordrar (Ordernummer),
	CONSTRAINT FK_Artikellista_Artikelnummer FOREIGN KEY (Artikelnummer)
    REFERENCES Kladesplagg (Artikelnummer)
);

INSERT INTO Kladesplagg
(
Modellnamn, Tillverkare, 
Tillverkningsland, Vikt, Storlek, 
Forsaljningspris, Inkopspris, Farg, 
Lagersaldo, Kategori, Typ, Kon
) 
VALUES
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam'),
('Sture', 'Gucci', 'Italien', 250.0, 'S', 2499.90, 1999.90, 'Blå', 25, 'Byxor', 'Shorts', 'Dam');

--SELECT * FROM Kladesplagg

