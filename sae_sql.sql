DROP TABLE IF EXISTS ligne_panier;
DROP TABLE IF EXISTS ligne_commande;
DROP TABLE IF EXISTS commande;
DROP TABLE IF EXISTS etat;
DROP TABLE IF EXISTS utilisateur;
DROP TABLE IF EXISTS velo;
DROP TABLE IF EXISTS type_velo;
DROP TABLE IF EXISTS taille;
DROP TABLE IF EXISTS couleur;
DROP TABLE IF EXISTS declinaison;


    CREATE TABLE couleur (
        id_couleur INT PRIMARY KEY AUTO_INCREMENT,
        libelle_couleur VARCHAR(50) NOT NULL
    );

    CREATE TABLE taille (
        id_taille INT PRIMARY KEY AUTO_INCREMENT,
        libelle_taille VARCHAR(10) NOT NULL
    );

    CREATE TABLE type_velo (
        id_type_velo INT PRIMARY KEY AUTO_INCREMENT,
        libelle_type_velo VARCHAR(50) NOT NULL
    );

    CREATE TABLE velo (
        id_velo INT PRIMARY KEY AUTO_INCREMENT,
        nom_velo VARCHAR(100) NOT NULL,
        prix_velo DECIMAL(10,2) NOT NULL,
        type_velo_id INT NOT NULL,
        matiere VARCHAR(50),
        description TEXT,
        fournisseur VARCHAR(100),
        marque VARCHAR(50),
        image VARCHAR(255),
        stock INT,
        FOREIGN KEY (taille_id) REFERENCES taille(id_taille),
        FOREIGN KEY (type_velo_id) REFERENCES type_velo(id_type_velo)
    );

    CREATE TABLE declinaison (
    id_declinaison INT PRIMARY KEY AUTO_INCREMENT,
    taille_id INT NOT NULL,
    couleur_id INT NOT NULL,
    velo_id INT NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    FOREIGN KEY (couleur_id) REFERENCES couleur(id_couleur),
    FOREIGN KEY (velo_id) REFERENCES velo(id_velo)
    );

    CREATE TABLE utilisateur(
        id_utilisateur INT AUTO_INCREMENT,
        login VARCHAR(255),
        password VARCHAR(255),
        email VARCHAR(255),
        role VARCHAR(255),
        est_actif tinyint(1),
        nom VARCHAR(255),
        PRIMARY KEY(id_utilisateur) 
    );

    CREATE TABLE etat (
        id_etat INT PRIMARY KEY AUTO_INCREMENT,
        libelle VARCHAR(50) NOT NULL
    );

    CREATE TABLE commande (
        id_commande INT PRIMARY KEY AUTO_INCREMENT,
        date_achat DATETIME NOT NULL,
        utilisateur_id INT NOT NULL,
        etat_id INT NOT NULL,
        FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(id_utilisateur),
        FOREIGN KEY (etat_id) REFERENCES etat(id_etat)
    );

    CREATE TABLE ligne_commande (
        commande_id INT NOT NULL,
        article_id INT NOT NULL,
        prix DECIMAL(10,2) NOT NULL,
        quantite INT NOT NULL,
        PRIMARY KEY (commande_id, article_id),
        FOREIGN KEY (commande_id) REFERENCES commande(id_commande),
        FOREIGN KEY (article_id) REFERENCES velo(id_velo)
    );

    CREATE TABLE ligne_panier (
        utilisateur_id INT NOT NULL,
        article_id INT NOT NULL,
        quantite INT NOT NULL,
        date_ajout DATETIME NOT NULL,
        PRIMARY KEY (utilisateur_id, article_id),
        FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(id_utilisateur),
        FOREIGN KEY (article_id) REFERENCES velo(id_velo)
    );

    INSERT INTO couleur (libelle_couleur) VALUES
    ('Noir'),
    ('Blanc'),
    ('Rouge'),
    ('Bleu'),
    ('Vert');

    INSERT INTO taille (libelle_taille) VALUES
    ('XS'),
    ('S'),
    ('M'),
    ('L'),
    ('XL');

    INSERT INTO type_velo (libelle_type_velo) VALUES
    ('VTT'),
    ('Vélo de route'),
    ('Vélo électrique'),
    ('Vélo cargo'),
    ('VTT électrique');

    INSERT INTO velo (nom_velo, prix_velo, type_velo_id, matiere, description, fournisseur, marque, image) VALUES
    ('VanMoof S3', 2298.00, 3, 'Aluminium', 'Vélo électrique intelligent avec technologie intégrée', 'VanMoof B.V.', 'VanMoof','VanMoof-S3.png'),
    ('Specialized Roubaix Pro SL8', 3999.00, 2, 'Carbone', 'Vélo de route haut de gamme avec technologie d''amortissement', 'Specialized Bicycle Components', 'Specialized','Specialized Roubaix Pro SL8.png'),
    ('Trek Domane SL 7', 5499.00, 2, 'Carbone', 'Vélo de course performant pour compétition et endurance', 'Trek Bicycle Corporation', 'Trek','Domane-SL7.png'),
    ('Canyon Endurace CF7', 3199.00, 2, 'Carbone', 'Vélo polyvalent pour longues distances et performances', 'Canyon Bicycles', 'Canyon','Endurance-CF-7.png'),
    ('Giant Propel Advanced 1', 4499.00, 2, 'Carbone', 'Vélo de course ultra-rapide et aérodynamique', 'Giant Manufacturing', 'Giant','Propel-Advanced-1.png'),
    ('Cannondale SuperSix EVO 4', 4799.00, 2, 'Carbone', 'Vélo de compétition léger et réactif', 'Cannondale Bicycle Corporation', 'Cannondale','Supersix-Evo-4.png'),
    ('Scott Spark RC', 5999.00, 1, 'Carbone', 'VTT léger et performant pour cross-country', 'Scott Sports SA', 'Scott','Vélo-SCOTT-Spark-RC-SL.png'),
    ('Orbea Orca M30', 4500.00, 2, 'Carbone', 'Vélo de course polyvalent et élégant', 'Orbea', 'Orbea','ORCA-M30.png'),
    ('Brompton Electric P Line Explore with Roller Frame', 2995.00, 3, 'Acier et aluminium', 'Vélo pliant électrique compact pour la ville', 'Brompton Bicycle Ltd', 'Brompton','Brompton Electric P Line Explore with Roller Frame.png'),
    ('BMC Roadmachine Two', 4799.00, 2, 'Carbone', 'Vélo confortable pour longues distances', 'BMC Switzerland', 'BMC','BMC-Roadmachine-TWO.png'),
    ('Santa Cruz Nomad', 6999.00, 1, 'Carbone', 'VTT enduro polyvalent pour terrain difficile', 'Santa Cruz Bicycles', 'Santa Cruz','Santa-Cruz-Nomad.png'),
    ('Endurance SL e - Sport Shimano 105 12-Speed', 3999.00, 3, 'Carbone', 'Vélo de route électrique haut de gamme', 'Ribble Cycles', 'Ribble','Endurance SL e - Sport Shimano 105 12-Speed.png'),
    ('Focus IZALCO MAX 9.9', 4299.00, 2, 'Carbone', 'Vélo de course léger et performant', 'Derby Cycle AG', 'Focus','Focus-IZALCO-MAX-9.9.png'),
    ('Lankeleisi MG800Max 2000W',2599.00, 5,'aluminium','VTT électrique avec une autonomie de 100km','Lankeleisi','Lankeleisi','Lankeleisi MG800Max 2000W.png'),
    ('BMC Teammachine R 01 Two Shimano Dura Ace Di2', 13999.00, 1, 'carbonne', 'VTT électrique avec une longue autonomie', 'BMC', 'BMC','BMC Teammachine R 01 Two Shimano Dura Ace Di2.png'),
    ('LOADY', 3929.00, 4, 'Titane', 'le vélo cargo longtail qui s adapte parfaitement à tous vos besoins.', 'velo-de-ville', 'velo-de-ville','Loady.png');

INSERT INTO utilisateur(id_utilisateur,login,email,password,role,nom,est_actif) VALUES
(1,'admin','admin@admin.fr',
    'sha256$dPL3oH9ug1wjJqva$2b341da75a4257607c841eb0dbbacb76e780f4015f0499bb1a164de2a893fdbf',
    'ROLE_admin','admin','1'),
(2,'client','client@client.fr',
    'sha256$1GAmexw1DkXqlTKK$31d359e9adeea1154f24491edaa55000ee248f290b49b7420ced542c1bf4cf7d',
    'ROLE_client','client','1'),
(3,'client2','client2@client2.fr',
    'sha256$MjhdGuDELhI82lKY$2161be4a68a9f236a27781a7f981a531d11fdc50e4112d912a7754de2dfa0422',
    'ROLE_client','client2','1');

INSERT INTO etat(libelle) VALUES
('en cours de traitement'),
('expédié'),
('validé');

INSERT INTO declinaison (taille_id, couleur_id, velo_id, stock) VALUES
-- VanMoof S3 (id_velo: 1)
(1, 1, 1, 5), (1, 2, 1, 3), -- XS: Noir(5), Blanc(3)
(2, 1, 1, 4), (2, 2, 1, 6), -- S: Noir(4), Blanc(6)
(3, 1, 1, 8), (3, 2, 1, 7), -- M: Noir(8), Blanc(7)
(4, 1, 1, 6), (4, 2, 1, 4), -- L: Noir(6), Blanc(4)
(5, 1, 1, 3), (5, 2, 1, 2), -- XL: Noir(3), Blanc(2)

-- Specialized Roubaix Pro SL8 (id_velo: 2)
(1, 1, 2, 4), (1, 3, 2, 3), -- XS: Noir(4), Rouge(3)
(2, 1, 2, 5), (2, 3, 2, 4), -- S: Noir(5), Rouge(4)
(3, 1, 2, 7), (3, 3, 2, 6), -- M: Noir(7), Rouge(6)
(4, 1, 2, 6), (4, 3, 2, 5), -- L: Noir(6), Rouge(5)
(5, 1, 2, 3), (5, 3, 2, 2), -- XL: Noir(3), Rouge(2)

-- Trek Domane SL 7 (id_velo: 3)
(1, 2, 3, 3), (1, 4, 3, 4), -- XS: Blanc(3), Bleu(4)
(2, 2, 3, 5), (2, 4, 3, 6), -- S: Blanc(5), Bleu(6)
(3, 2, 3, 8), (3, 4, 3, 7), -- M: Blanc(8), Bleu(7)
(4, 2, 3, 6), (4, 4, 3, 5), -- L: Blanc(6), Bleu(5)
(5, 2, 3, 2), (5, 4, 3, 3), -- XL: Blanc(2), Bleu(3)

-- Canyon Endurace CF7 (id_velo: 4)
(1, 1, 4, 4), (1, 5, 4, 3), -- XS: Noir(4), Vert(3)
(2, 1, 4, 6), (2, 5, 4, 5), -- S: Noir(6), Vert(5)
(3, 1, 4, 8), (3, 5, 4, 7), -- M: Noir(8), Vert(7)
(4, 1, 4, 5), (4, 5, 4, 4), -- L: Noir(5), Vert(4)
(5, 1, 4, 3), (5, 5, 4, 2), -- XL: Noir(3), Vert(2)

-- Giant Propel Advanced 1 (id_velo: 5)
(1, 2, 5, 3), (1, 3, 5, 4), -- XS: Blanc(3), Rouge(4)
(2, 2, 5, 5), (2, 3, 5, 6), -- S: Blanc(5), Rouge(6)
(3, 2, 5, 7), (3, 3, 5, 8), -- M: Blanc(7), Rouge(8)
(4, 2, 5, 4), (4, 3, 5, 5), -- L: Blanc(4), Rouge(5)
(5, 2, 5, 2), (5, 3, 5, 3), -- XL: Blanc(2), Rouge(3)

-- Cannondale SuperSix EVO 4 (id_velo: 6)
(1, 1, 6, 4), (1, 4, 6, 3), -- XS: Noir(4), Bleu(3)
(2, 1, 6, 6), (2, 4, 6, 5), -- S: Noir(6), Bleu(5)
(3, 1, 6, 8), (3, 4, 6, 7), -- M: Noir(8), Bleu(7)
(4, 1, 6, 5), (4, 4, 6, 4), -- L: Noir(5), Bleu(4)
(5, 1, 6, 3), (5, 4, 6, 2), -- XL: Noir(3), Bleu(2)

-- Scott Spark RC (id_velo: 7)
(1, 2, 7, 3), (1, 5, 7, 4), -- XS: Blanc(3), Vert(4)
(2, 2, 7, 5), (2, 5, 7, 6), -- S: Blanc(5), Vert(6)
(3, 2, 7, 7), (3, 5, 7, 8), -- M: Blanc(7), Vert(8)
(4, 2, 7, 4), (4, 5, 7, 5), -- L: Blanc(4), Vert(5)
(5, 2, 7, 2), (5, 5, 7, 3), -- XL: Blanc(2), Vert(3)

-- Orbea Orca M30 (id_velo: 8)
(1, 1, 8, 4), (1, 3, 8, 3), -- XS: Noir(4), Rouge(3)
(2, 1, 8, 6), (2, 3, 8, 5), -- S: Noir(6), Rouge(5)
(3, 1, 8, 8), (3, 3, 8, 7), -- M: Noir(8), Rouge(7)
(4, 1, 8, 5), (4, 3, 8, 4), -- L: Noir(5), Rouge(4)
(5, 1, 8, 3), (5, 3, 8, 2), -- XL: Noir(3), Rouge(2)

-- Brompton Electric P Line (id_velo: 9)
(1, 2, 9, 3), (1, 4, 9, 4), -- XS: Blanc(3), Bleu(4)
(2, 2, 9, 5), (2, 4, 9, 6), -- S: Blanc(5), Bleu(6)
(3, 2, 9, 7), (3, 4, 9, 8), -- M: Blanc(7), Bleu(8)
(4, 2, 9, 4), (4, 4, 9, 5), -- L: Blanc(4), Bleu(5)
(5, 2, 9, 2), (5, 4, 9, 3), -- XL: Blanc(2), Bleu(3)

-- BMC Roadmachine Two (id_velo: 10)
(1, 1, 10, 4), (1, 5, 10, 3), -- XS: Noir(4), Vert(3)
(2, 1, 10, 6), (2, 5, 10, 5), -- S: Noir(6), Vert(5)
(3, 1, 10, 8), (3, 5, 10, 7), -- M: Noir(8), Vert(7)
(4, 1, 10, 5), (4, 5, 10, 4), -- L: Noir(5), Vert(4)
(5, 1, 10, 3), (5, 5, 10, 2), -- XL: Noir(3), Vert(2)

-- Santa Cruz Nomad (id_velo: 11)
(1, 2, 11, 3), (1, 3, 11, 4), -- XS: Blanc(3), Rouge(4)
(2, 2, 11, 5), (2, 3, 11, 6), -- S: Blanc(5), Rouge(6)
(3, 2, 11, 7), (3, 3, 11, 8), -- M: Blanc(7), Rouge(8)
(4, 2, 11, 4), (4, 3, 11, 5), -- L: Blanc(4), Rouge(5)
(5, 2, 11, 2), (5, 3, 11, 3), -- XL: Blanc(2), Rouge(3)

-- Endurance SL e (id_velo: 12)
(1, 1, 12, 4), (1, 4, 12, 3), -- XS: Noir(4), Bleu(3)
(2, 1, 12, 6), (2, 4, 12, 5), -- S: Noir(6), Bleu(5)
(3, 1, 12, 8), (3, 4, 12, 7), -- M: Noir(8), Bleu(7)
(4, 1, 12, 5), (4, 4, 12, 4), -- L: Noir(5), Bleu(4)
(5, 1, 12, 3), (5, 4, 12, 2), -- XL: Noir(3), Bleu(2)

-- Focus IZALCO MAX 9.9 (id_velo: 13)
(1, 2, 13, 3), (1, 5, 13, 4), -- XS: Blanc(3), Vert(4)
(2, 2, 13, 5), (2, 5, 13, 6), -- S: Blanc(5), Vert(6)
(3, 2, 13, 7), (3, 5, 13, 8), -- M: Blanc(7), Vert(8)
(4, 2, 13, 4), (4, 5, 13, 5), -- L: Blanc(4), Vert(5)
(5, 2, 13, 2), (5, 5, 13, 3), -- XL: Blanc(2), Vert(3)

-- Lankeleisi MG800Max (id_velo: 14)
(1, 1, 14, 4), (1, 3, 14, 3), -- XS: Noir(4), Rouge(3)
(2, 1, 14, 6), (2, 3, 14, 5), -- S: Noir(6), Rouge(5)
(3, 1, 14, 8), (3, 3, 14, 7), -- M: Noir(8), Rouge(7)
(4, 1, 14, 5), (4, 3, 14, 4), -- L: Noir(5), Rouge(4)
(5, 1, 14, 3), (5, 3, 14, 2), -- XL: Noir(3), Rouge(2)

-- BMC Teammachine (id_velo: 15)
(1, 2, 15, 3), (1, 4, 15, 4), -- XS: Blanc(3), Bleu(4)
(2, 2, 15, 5), (2, 4, 15, 6), -- S: Blanc(5), Bleu(6)
(3, 2, 15, 7), (3, 4, 15, 8), -- M: Blanc(7), Bleu(8)
(4, 2, 15, 4), (4, 4, 15, 5), -- L: Blanc(4), Bleu(5)
(5, 2, 15, 2), (5, 4, 15, 3), -- XL: Blanc(2), Bleu(3)

-- LOADY (id_velo: 16)
(1, 1, 16, 4), (1, 5, 16, 3), -- XS: Noir(4), Vert(3)
(2, 1, 16, 6), (2, 5, 16, 5), -- S: Noir(6), Vert(5)
(3, 1, 16, 8), (3, 5, 16, 7), -- M: Noir(8), Vert(7)
(4, 1, 16, 5), (4, 5, 16, 4), -- L: Noir(5), Vert(4)
(5, 1, 16, 3), (5, 5, 16, 2); -- XL: Noir(3), Vert(2)

SELECT v.nom_velo, v.prix_velo, t.libelle_taille, tv.libelle_type_velo
FROM velo v
JOIN taille t ON v.taille_id = t.id_taille
JOIN type_velo tv ON v.type_velo_id = tv.id_type_velo
ORDER BY v.prix_velo DESC;

SELECT tv.libelle_type_velo, COUNT(*) as nombre_velos
FROM velo v
JOIN type_velo tv ON v.type_velo_id = tv.id_type_velo
GROUP BY tv.libelle_type_velo;

SELECT nom_velo, prix_velo, matiere
FROM velo
WHERE matiere LIKE '%carbone%' AND prix_velo > 4000
ORDER BY prix_velo;

SELECT tv.libelle_type_velo, ROUND(AVG(v.prix_velo), 2) as prix_moyen
FROM velo v
JOIN type_velo tv ON v.type_velo_id = tv.id_type_velo
GROUP BY tv.libelle_type_velo;

SELECT login, email, role
FROM utilisateur
ORDER BY role;

SELECT v.nom_velo, v.prix_velo, t.libelle_taille
FROM velo v
JOIN taille t ON v.taille_id = t.id_taille
WHERE t.libelle_taille = 'XL';

SELECT DISTINCT marque
FROM velo
ORDER BY marque;

SELECT v.nom_velo, t.libelle_taille, c.libelle_couleur, d.stock
FROM declinaison d
JOIN velo v ON d.velo_id = v.id_velo 
JOIN taille t ON d.taille_id = t.id_taille
JOIN couleur c ON d.couleur_id = c.id_couleur
ORDER BY v.nom_velo, t.libelle_taille, c.libelle_couleur;


