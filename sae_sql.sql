DROP TABLE IF EXISTS ligne_panier;
DROP TABLE IF EXISTS ligne_commande;
DROP TABLE IF EXISTS commande;
DROP TABLE IF EXISTS etat;
DROP TABLE IF EXISTS utilisateur;
DROP TABLE IF EXISTS velo;
DROP TABLE IF EXISTS type_velo;
DROP TABLE IF EXISTS taille;
DROP TABLE IF EXISTS couleur;
DROP TABLE IF EXISTS declinaison_velo;


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
        taille_id INT NOT NULL,
        type_velo_id INT NOT NULL,
        matiere VARCHAR(50),
        description TEXT,
        fournisseur VARCHAR(100),
        marque VARCHAR(50),
        image VARCHAR(255),
        FOREIGN KEY (taille_id) REFERENCES taille(id_taille),
        FOREIGN KEY (type_velo_id) REFERENCES type_velo(id_type_velo)
    );

    CREATE TABLE declinaison_velo (
        id_declinaison INT PRIMARY KEY AUTO_INCREMENT,
        velo_id INT NOT NULL,
        couleur_id INT NOT NULL,
        taille_id INT NOT NULL,
        stock INT NOT NULL DEFAULT 0,
        FOREIGN KEY (velo_id) REFERENCES velo(id_velo),
        FOREIGN KEY (couleur_id) REFERENCES couleur(id_couleur),
        FOREIGN KEY (taille_id) REFERENCES taille(id_taille)
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

    INSERT INTO couleur (id_couleur, libelle_couleur) VALUES
    (1, 'Rouge'),
    (2, 'Bleu'),
    (3, 'Vert'),
    (4, 'Jaune'),
    (5, 'Noir');

    INSERT INTO taille (libelle_taille) VALUES
    ('XS'), -- 1
    ('S'), -- 2
    ('M'), -- 3
    ('L'), -- 4
    ('XL'); -- 5

    INSERT INTO type_velo (libelle_type_velo) VALUES
    ('VTT'), -- 1
    ('Vélo de route'), -- 2
    ('Vélo électrique'), -- 3
    ('Vélo cargo'), -- 4
    ('VTT électrique'); -- 5


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

INSERT INTO declinaison_velo (velo_id, couleur_id, taille_id, stock) VALUES
(1, 1, 2, 5), (1, 2, 2, 3), (1, 5, 3, 4),
(2, 5, 4, 2), (2, 3, 4, 4), (2, 5, 3, 3), (2, 3, 3, 2),
(3, 5, 2, 3), (3, 5, 3, 4), (3, 3, 2, 2),
(4, 1, 1, 2), (4, 1, 2, 3), (4, 2, 1, 2),
(5, 2, 3, 4), (5, 2, 4, 3), (5, 5, 3, 2),
(6, 5, 5, 2), (6, 5, 4, 3), (6, 3, 5, 2),
(7, 1, 1, 3), (7, 2, 1, 2), (7, 5, 1, 4),
(8, 5, 5, 3), (8, 3, 5, 2), (8, 5, 4, 4),
(9, 5, 4, 3), (9, 3, 4, 2), (9, 4, 4, 4),
(10, 5, 3, 3), (10, 5, 4, 2), (10, 3, 3, 4), (10, 3, 4, 3);

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

SELECT 
    v.nom_velo,
    c.libelle_couleur,
    t.libelle_taille,
    SUM(dv.stock) as stock_couleur
FROM velo v
LEFT JOIN declinaison_velo dv ON v.id_velo = dv.velo_id
LEFT JOIN taille t ON dv.taille_id = t.id_taille
LEFT JOIN couleur c ON dv.couleur_id = c.id_couleur
WHERE dv.stock > 0
GROUP BY v.nom_velo, c.libelle_couleur, t.libelle_taille;