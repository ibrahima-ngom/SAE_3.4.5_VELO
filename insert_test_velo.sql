-- Insertion d'un vélo de test avec plusieurs déclinaisons
INSERT INTO velo (nom_velo, prix_velo, type_velo_id, matiere, description, fournisseur, marque, image)
VALUES ('Vélo Test Multi-Déclinaisons', 399.99, 1, 'Aluminium', 'Vélo de test avec plusieurs déclinaisons', 'Fournisseur Test', 'Marque Test', 'test_bike.jpg');

-- Récupération de l'ID du vélo inséré
SET @id_velo = LAST_INSERT_ID();

-- Insertion des déclinaisons avec différents stocks
INSERT INTO declinaison (velo_id, couleur_id, taille_id, stock)
VALUES 
    (@id_velo, 1, 1, 2),  -- Rouge, Taille S, Stock: 2
    (@id_velo, 1, 2, 5),  -- Rouge, Taille M, Stock: 5
    (@id_velo, 2, 1, 3),  -- Bleu, Taille S, Stock: 3
    (@id_velo, 2, 2, 1),  -- Bleu, Taille M, Stock: 1
    (@id_velo, 3, 1, 4),  -- Noir, Taille S, Stock: 4
    (@id_velo, 3, 2, 0);  -- Noir, Taille M, Stock: 0 (pour tester l'indisponibilité) 