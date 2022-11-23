CREATE DATABASE db_brief_financial_bis;

USE db_brief_financial_bis;

CREATE TABLE Trader (
    nom varchar(255) NOT NULL,
    classe_actif varchar(255) NOT NULL,
    anneesExperience int(12) NOT NULL,
    nomEquipe varchar(255) NOT NULL,
    PRIMARY KEY (nom),
    FOREIGN KEY (nomEquipe) REFERENCES db_brief_financial_bis.Equipe(nom)
);


CREATE TABLE Equipe (
    nom varchar(255) NOT NULL,
    style varchar(255) NOT NULL,
    chef varchar(255) NOT NULL,
    PRIMARY KEY (nom)
);

CREATE TABLE Transaction (
    nom varchar(255),
    date date NOT NULL,
    lieu varchar(255) NOT NULL,
    prix int(12) NOT NULL,
    nomEquipe varchar(255) NOT NULL,
    PRIMARY KEY (nom),
    FOREIGN KEY (nomEquipe) REFERENCES db_brief_financial_bis.Equipe(nom)
);

INSERT INTO Transaction (nom, date, lieu, prix, nomEquipe)
 VALUES
 ('AXA SA', '2021/06/15', 'PARIS', 26, 'Equipe1'),
 ('TotalEnergies', '2004/09/03', 'PARIS', 57, 'Equipe2'),
 ('Apple Inc', '2014/09/05', 'USA', 150, 'Equipe1'),
 ('Dubai Elec', '2020/11/22', 'DUBAI', 1, 'Equipe3'),
 ('Amazon', '2010/07/12', 'USA', 100, 'Equipe3'),
 ('Naspers', '1997/08/16', 'SOUTH AFRICA', 120, 'Equipe2'),
 ('PetroChina', '2019/04/20', 'HONG KONG', 10, 'Equipe5'),
 ('ETF Vanguard', '2015/02/22', 'LA', 200, 'Equipe7'),
 ('DassaultAviation', '2016/01/01', 'PARIS', 140, 'Equipe6');

INSERT INTO Trader (nom, classe_actif, anneesExperience, nomEquipe)
 VALUES
 ('Yannick', 'fixed income', 10, 'Equipe1'),
 ('Patrick', 'action', 10, 'Equipe1'),
 ('Cedrick', 'commodities', 10, 'Equipe1'),
 ('Jordan', 'change', 2, 'Equipe2'),
 ('Gaelle', 'exotic', 4, 'Equipe3'),
 ('Georges', 'CDS', 20, 'Equipe6');

INSERT INTO Equipe (nom, style, chef)
 VALUES
 ('Equipe1', 'marketing making', 'leonardo'),
 ('Equipe2', 'arbitrage', 'michaelgelo'),
 ('Equipe3', 'trading de volatilite', 'raphael'),
 ('Equipe4', 'trading de haute frequence', 'donatello'),
 ('Equipe5', 'arbitrage statisque', 'Smith'),
 ('Equipe6', 'arbitrage statisque', 'Smith'),
 ('Equipe7', 'strategie fond de fond', 'Ray');


--mf01
SELECT nom, classe_actif
FROM trader
WHERE anneesExperience < 5

--mf02
SELECT classe_actif
FROM trader
WHERE nomEquipe = "Equipe1"
GROUP BY classe_actif

--mf03
SELECT *
FROM trader
WHERE classe_actif = "commodities"

--mf04
SELECT classe_actif
FROM trader
WHERE anneesExperience > 20
GROUP BY classe_actif

--mf05
SELECT nom
FROM trader
WHERE anneesExperience >= 5 AND anneesExperience <= 10

--mf06
SELECT classe_actif
FROM trader
WHERE classe_actif LIKE "ch%"
GROUP BY classe_actif

--mf07
SELECT nom
FROM Equipe
WHERE style = "arbitrage statisque"

--mf08
SELECT nom
FROM Equipe
WHERE chef = "Smith"

--mf09
SELECT *
FROM Transaction
ORDER BY nom ASC

--mf10
SELECT *
FROM Transaction
WHERE date = '2019/04/20' AND lieu LIKE 'HONG KONG';

--mf11
SELECT lieu
FROM Transaction
WHERE prix > 150;

--mf12
SELECT *
FROM Transaction
WHERE prix < 50 AND lieu LIKE 'PARIS';

--mf13
SELECT lieu     --<-Bonne méthode          on peu aussi faire ->  SELECT lieu
FROM Transaction     --                                           FROM Transaction
WHERE year(date) = 2014;     --                                   WHERE date LIKE '%2014%'

--mmtj01
SELECT Trader.nom, Trader.classe_actif
FROM Trader
JOIN Equipe ON Trader.nomEquipe = Equipe.nom
WHERE Trader.anneesExperience > 3 AND Equipe.style = "arbitrage statisque"
ORDER BY Trader.nom ASC

--mmtj02
SELECT lieu, Transaction.nom
FROM Transaction
JOIN Equipe ON Transaction.nomEquipe = Equipe.nom
WHERE Equipe.chef = "Smith" AND Transaction.prix < 20
ORDER BY Transaction.lieu ASC

--mmtj03
SELECT count(Transaction.nom)
FROM Transaction
JOIN Equipe ON Transaction.nomEquipe = Equipe.nom
WHERE year(date) = 2021 AND Equipe.style = "marketing making"

--mmtj04
SELECT lieu, AVG(Transaction.prix)
FROM Transaction
JOIN Equipe ON Transaction.nomEquipe = Equipe.nom
WHERE Equipe.style = "marketing making"
GROUP BY Transaction.lieu

--mmtj05
SELECT Trader.classe_actif
FROM Trader
JOIN Equipe ON Trader.nomEquipe = Equipe.nom
JOIN Transaction ON Transaction.nomEquipe = Equipe.nom
WHERE Equipe.chef = "Smith" AND Transaction.date = "2016/01/01"

--mmtj21
SELECT Equipe.style, AVG(Trader.anneesExperience)
FROM Trader
JOIN Equipe ON Trader.nomEquipe = Equipe.nom
GROUP BY Equipe.style

--mmts01
SELECT Trader.nom, Trader.classe_actif
FROM Trader
WHERE Trader.anneesExperience > 3 AND nomEquipe IN  (
    SELECT nom
    FROM Equipe
    WHERE Equipe.style = "arbitrage statisque"
  )
ORDER BY Trader.nom ASC

--on peu aussi faire
SELECT Trader.nom, Trader.classe_actif
FROM Trader, Equipe
WHERE Trader.anneesExperience > 3 AND Trader.nomEquipe = Equipe.nom
ORDER BY Trader.nom ASC

--mmts02
SELECT Transaction.lieu
FROM Transaction
WHERE Transaction.prix < 20 AND Transaction.nomEquipe IN  (
    SELECT nom
    FROM Equipe
    WHERE Equipe.chef = 'Smith'
  )
ORDER BY Transaction.lieu ASC

--mmts03
SELECT count(Transaction.lieu) as nb_market
FROM Transaction
WHERE year(Transaction.date) = 2015 AND Transaction.nomEquipe IN  (
    SELECT nom
    FROM Equipe
    WHERE Equipe.style = 'trading de volatilite'
  )

--mmts04
SELECT AVG(Transaction.prix) as mean_price_marketing_making, Transaction.lieu
FROM Transaction
WHERE Transaction.nomEquipe IN  (
    SELECT nom
    FROM Equipe
    WHERE Equipe.style = 'marketing making'
  )
GROUP BY Transaction.lieu

--mmts05
SELECT Trader.classe_actif
FROM Trader
WHERE  Trader.nomEquipe IN  (
    SELECT nom
    FROM Equipe
    WHERE Equipe.chef = "Smith" AND Equipe.nom IN  (
        SELECT nomEquipe
        FROM Transaction
        WHERE Transaction.date = "2016/01/01"
    )
  )



