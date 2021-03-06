-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le :  lun. 11 mai 2020 à 00:17
-- Version du serveur :  5.7.26
-- Version de PHP :  7.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `v_green`
--

DELIMITER $$
--
-- Procédures
--
DROP PROCEDURE IF EXISTS `calcul_ca`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `calcul_ca` ()  BEGIN
    SELECT `LIG_QUANTITE` * `PRO_PRIX_ACHAT`
    FROM `produits`
    JOIN `ligne_de_commande`
    ON `ligne_de_commande`.`PRO_ID` = `produits`.`PRO_ID`;
END$$

DROP PROCEDURE IF EXISTS `DelFourniPro`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `DelFourniPro` ()  BEGIN 
DELETE FROM `fournisseurs` 
WHERE `FOU_ID`=`FOU_ID`;

END$$

DROP PROCEDURE IF EXISTS `liste_produits`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `liste_produits` ()  BEGIN
	SELECT pro_id,pro_title,pro_price FROM produits;
END$$

DROP PROCEDURE IF EXISTS `liste_produits_par_titre`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `liste_produits_par_titre` (IN `pro_title` VARCHAR(100))  BEGIN
	SELECT pro_id,pro_lib,pro_price FROM produits
    WHERE pro_id = 7;
END$$

DROP PROCEDURE IF EXISTS `liste_quelconque`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `liste_quelconque` (IN `title` VARCHAR(100))  BEGIN
	SELECT pro_id,pro_title,pro_price FROM produits
    WHERE pro_title = title;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `categorie`
--

DROP TABLE IF EXISTS `categorie`;
CREATE TABLE IF NOT EXISTS `categorie` (
  `CAT_ID` int(11) NOT NULL AUTO_INCREMENT,
  `CAT_LIBELLE` varchar(50) DEFAULT NULL,
  `Cat_cat_id` int(11) NOT NULL,
  `PER_ID` int(11) NOT NULL,
  `CAT_D_AJOUT` date DEFAULT NULL,
  `CAT_D_MODIF` date DEFAULT NULL,
  PRIMARY KEY (`CAT_ID`),
  KEY `FK_cat_cat_id` (`Cat_cat_id`),
  KEY `FK_per_id` (`PER_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `categorie`
--

INSERT INTO `categorie` (`CAT_ID`, `CAT_LIBELLE`, `Cat_cat_id`, `PER_ID`, `CAT_D_AJOUT`, `CAT_D_MODIF`) VALUES
(1, 'guitare', 1, 1, NULL, NULL),
(2, 'batterie', 2, 2, NULL, NULL),
(3, 'piano', 3, 3, NULL, NULL),
(4, 'studio', 4, 4, NULL, NULL),
(5, 'eclairage', 5, 5, NULL, NULL),
(6, 'dj', 6, 6, NULL, NULL),
(7, 'cases', 7, 7, NULL, NULL),
(8, 'accessoires', 8, 8, NULL, NULL),
(9, 'instrument a vent', 9, 9, NULL, NULL),
(10, 'instrument a corde', 10, 10, '2020-05-05', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `clients`
--

DROP TABLE IF EXISTS `clients`;
CREATE TABLE IF NOT EXISTS `clients` (
  `CLI_ID` int(11) NOT NULL AUTO_INCREMENT,
  `PER_ID` int(11) NOT NULL,
  `CLI_NOM` varchar(50) DEFAULT NULL,
  `CLI_PRENOM` varchar(50) DEFAULT NULL,
  `CLI_MAIL` varchar(50) DEFAULT NULL,
  `CLI_MDP` varchar(60) DEFAULT NULL,
  `CLI_REF` varchar(50) DEFAULT NULL,
  `CLI_TYPE` bit(1) DEFAULT NULL,
  `CLI_ADRESSE_FACTURATION` varchar(50) DEFAULT NULL,
  `CLI_DATE_INSCRIPTION` datetime DEFAULT NULL,
  `CLI_COEFFICEINT` float DEFAULT NULL,
  PRIMARY KEY (`CLI_ID`),
  KEY `FK_per_id3` (`PER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `commande`
--

DROP TABLE IF EXISTS `commande`;
CREATE TABLE IF NOT EXISTS `commande` (
  `COM_ID` int(11) NOT NULL AUTO_INCREMENT,
  `PER_ID` int(11) NOT NULL,
  `CLI_ID` int(11) NOT NULL,
  `COM_ADRESSE_LIVRAISON` varchar(500) DEFAULT NULL,
  `COM_TYPE_PAIEMENT` bit(1) DEFAULT NULL,
  `COM_DATE_PAIEMENT` int(11) DEFAULT NULL,
  `COM_DATE_COMMANDE` int(11) DEFAULT NULL,
  `COM_MONTANT_REMISE` float DEFAULT NULL,
  `COM_ETAT` int(11) DEFAULT NULL,
  PRIMARY KEY (`COM_ID`),
  KEY `FK_cli_id` (`CLI_ID`),
  KEY `FK_per_id2` (`PER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déclencheurs `commande`
--
DROP TRIGGER IF EXISTS `Uproduits`;
DELIMITER $$
CREATE TRIGGER `Uproduits` AFTER UPDATE ON `commande` FOR EACH ROW BEGIN

SELECT * INTO @ligne_de_commande  FROM `ligne_de_commande`
JOIN `produits` ON `ligne_de_commande`.`PRO_ID` = `produits`.`PRO_ID`
JOIN `commande` ON `ligne_de_commande`.`COM_Id` = `commande`.`COM_ID`;
UPDATE `produits`
SET `PRO_STOCK_PHYSIQUE`= (`PRO_STOCK_PHYSIQUE`-`LIG_QUANTITE`)
WHERE `PRO_ID`= `PRO_ID`;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `commandefournisseurs`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `commandefournisseurs`;
CREATE TABLE IF NOT EXISTS `commandefournisseurs` (
`COM_ID` int(11)
,`FOU_REF` varchar(50)
,`LIG_QUANTITE` int(11)
,`PRO_REF` varchar(50)
);

-- --------------------------------------------------------

--
-- Structure de la table `commande_clients`
--

DROP TABLE IF EXISTS `commande_clients`;
CREATE TABLE IF NOT EXISTS `commande_clients` (
  `CLI_NOM` varchar(50) DEFAULT NULL,
  `CLI_PRENOM` varchar(50) DEFAULT NULL,
  `CLI_REF` varchar(50) DEFAULT NULL,
  `CLI_TYPE` bit(1) DEFAULT NULL,
  `CLI_MAIL` varchar(50) DEFAULT NULL,
  `COM_ETAT` int(11) DEFAULT NULL,
  `COM_DATE_COMMANDE` int(11) DEFAULT NULL,
  `COM_DATE_PAIEMENT` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `commande_fournisseurs`
--

DROP TABLE IF EXISTS `commande_fournisseurs`;
CREATE TABLE IF NOT EXISTS `commande_fournisseurs` (
  `FOU_REF` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `fournir`
--

DROP TABLE IF EXISTS `fournir`;
CREATE TABLE IF NOT EXISTS `fournir` (
  `PRO_ID` int(11) NOT NULL,
  `FOU_ID` int(11) NOT NULL,
  PRIMARY KEY (`PRO_ID`,`FOU_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `fournisseurs`
--

DROP TABLE IF EXISTS `fournisseurs`;
CREATE TABLE IF NOT EXISTS `fournisseurs` (
  `FOU_ID` int(11) NOT NULL AUTO_INCREMENT,
  `FOU_ADRESSE` varchar(50) DEFAULT NULL,
  `FOU_REF` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`FOU_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `gerer2`
--

DROP TABLE IF EXISTS `gerer2`;
CREATE TABLE IF NOT EXISTS `gerer2` (
  `PRO_ID` int(11) NOT NULL,
  `PER_ID` int(11) NOT NULL,
  PRIMARY KEY (`PRO_ID`,`PER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `infos_contact_client`
--

DROP TABLE IF EXISTS `infos_contact_client`;
CREATE TABLE IF NOT EXISTS `infos_contact_client` (
  `CLI_ID` int(11) DEFAULT NULL,
  `CLI_REF` varchar(50) DEFAULT NULL,
  `CLI_TYPE` bit(1) DEFAULT NULL,
  `CLI_MAIL` varchar(50) DEFAULT NULL,
  `CLI_ADRESSE_FACTURATION` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `ligne_de_commande`
--

DROP TABLE IF EXISTS `ligne_de_commande`;
CREATE TABLE IF NOT EXISTS `ligne_de_commande` (
  `LIG_ID` int(11) NOT NULL AUTO_INCREMENT,
  `COM_ID` int(11) NOT NULL,
  `PRO_ID` int(11) NOT NULL,
  `LIG_QUANTITE` int(11) DEFAULT NULL,
  PRIMARY KEY (`LIG_ID`),
  KEY `FK_com_id` (`COM_ID`),
  KEY `FK_pro_id2` (`PRO_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `livraison`
--

DROP TABLE IF EXISTS `livraison`;
CREATE TABLE IF NOT EXISTS `livraison` (
  `LIV_ID` int(11) NOT NULL,
  `LIG_ID` int(11) NOT NULL,
  `LIV_DATE` datetime DEFAULT NULL,
  `LIV_QUANTITE` int(11) DEFAULT NULL,
  PRIMARY KEY (`LIV_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `livraisonsclients`
--

DROP TABLE IF EXISTS `livraisonsclients`;
CREATE TABLE IF NOT EXISTS `livraisonsclients` (
  `LIV_DATE` datetime DEFAULT NULL,
  `CLI_REF` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `personnels`
--

DROP TABLE IF EXISTS `personnels`;
CREATE TABLE IF NOT EXISTS `personnels` (
  `PER_ID` int(11) NOT NULL AUTO_INCREMENT,
  `PER_MATRICULE` varchar(50) DEFAULT NULL,
  `PER_SERVICE` varchar(50) DEFAULT NULL,
  `COEFICIENT_COMMERCIAL` float DEFAULT NULL,
  PRIMARY KEY (`PER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `produits`
--

DROP TABLE IF EXISTS `produits`;
CREATE TABLE IF NOT EXISTS `produits` (
  `PRO_ID` int(11) NOT NULL AUTO_INCREMENT,
  `CAT_ID` int(11) NOT NULL,
  `PRO_LIBELLE` varchar(50) DEFAULT NULL,
  `PRO_REF` varchar(50) DEFAULT NULL,
  `PRO_DESCRIPTION` varchar(500) DEFAULT NULL,
  `PRO_PRIX_ACHAT` float DEFAULT NULL,
  `PRO_PHOTO` varchar(255) DEFAULT NULL,
  `PRO_STOCK_PHYSIQUE` int(11) DEFAULT NULL,
  `PRO_STOCK_ALERTE` int(11) DEFAULT NULL,
  `PRO_SLUG` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`PRO_ID`),
  KEY `FK_cat_id` (`CAT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `produits`
--

INSERT INTO `produits` (`PRO_ID`, `CAT_ID`, `PRO_LIBELLE`, `PRO_REF`, `PRO_DESCRIPTION`, `PRO_PRIX_ACHAT`, `PRO_PHOTO`, `PRO_STOCK_PHYSIQUE`, `PRO_STOCK_ALERTE`, `PRO_SLUG`) VALUES
(5, 1, 'Harley Benton', 'gui000', 'Harley Benton est une marque crée pour et distribuée par le détaillant allemand Thomann. Crée en 19971, elle propose des guitares, basses, banjos, mandolines, microphones, amplificateurs, pédales d\'effet, des cordes, des médiators, des pièces détachées, etc', 1860, 'png', 0, NULL, 'Harley_Benton'),
(6, 1, 'Delson Sevilla', 'gui001', 'La manche et la table de ce modèle d\'instrument sont faites en épicéa de Californie avec un dos et côté en érable', 394.99, 'png', 0, NULL, 'Delson_Sevilla'),
(7, 1, 'Gibson ES 335', 'gui003', 'L\'ES-335 était une tentative de trouver un terrain d\'entente: un ton plus chaud qu\'un corps solide produit avec presque aussi peu de rétroaction', 800, 'png', 2, NULL, 'Gibson_ES_335'),
(8, 1, 'Gibson Thunderbird', 'bass000', 'Le Thunderbird a été conçu par le concepteur automobile américain Raymond H. Dietrich (Chrysler, Lincoln, Checker)', 1999.99, 'png', 1, NULL, 'Gibson_Thunderbird'),
(9, 1, 'Gibson Lespaul', 'bass001', 'Le premier modèle simplement appelé \"Les Paul Bass\", avait quelques caractéristiques intéressantes, notamment des circuits basse impédance, spécialement conçus pour l\'enregistrement en studio.\r\n', 2039, 'png', 1, NULL, 'Gibson_Lespaul'),
(10, 1, 'Gipson pat martino', 'bass002', 'Basse semi acoustique en l\'honneur de Pat Martino.', 3449.99, 'png', 1, NULL, 'Gipson_pat_martino'),
(11, 1, 'SpongeBob', 'uku000', 'Who lives in a pineapple under the sea?\r\nSpongebob Squarepant!', 14.99, 'png', 1, NULL, 'SpongeBob'),
(12, 10, 'onsenfou', 'cor000', 'ujgfuyf', 99.98, 'jpg', 1, NULL, 'onsenfou'),
(13, 2, 'Pearl', 'bat000', 'Les batteries pour débutants.', 550.5, 'png', 1, NULL, 'Pearl'),
(14, 3, 'Kawai ES-8 B', 'pia000', 'Un clavier électronique, un clavier portable ou un clavier numérique est un instrument de musique électronique.', 1256, 'png', 2, NULL, 'Kawai_ES-8_B'),
(15, 4, 'Trident audio', 'stu000', 'Les consoles analogiques de la série 68 ont été développées pour fournir l\'ensemble de fonctionnalités de base le plus souvent nécessaire pour l\'enregistrement analogique.', 9999.99, 'png', 1, NULL, 'Trident_audio'),
(16, 5, 'Projecteur LED DMX512', 'ecl000', 'éclairage led dmx512 classique.', 56.75, 'png', 4, NULL, 'Projecteur_LED_DMX512'),
(17, 6, 'FF-4000', 'tab000', 'une table de dj, houlala vive la description..', 1429, 'png', 1, NULL, 'FF-4000'),
(18, 7, 'Flyht pro case', 'cas000', 'c\'est une boite, voila.', 129, 'png', 4, NULL, 'Flyht_pro_case'),
(19, 8, 'Shure sm7b', 'acc000', 'etrange outil porteur de maladie mais qui permet d\'être audible, après tout dépend de celui qui l\'utilise.', 366.66, 'png', 0, NULL, 'Shure_sm7b'),
(20, 8, 'Cordial cfu 1.5', 'acc001', 'Un câble d’amplis', 14.99, 'png', 0, NULL, 'Cordial_cfu_1.5'),
(21, 9, 'Startone', 'ven000', 'Le saxophone est un instrument de musique à vent appartenant à la famille des bois. Il a été inventé par le Belge Adolphe Sax et breveté à Paris le 21 mars 1846.', 620, 'png', 4, NULL, 'Startone');

-- --------------------------------------------------------

--
-- Structure de la table `produit_visible_clients`
--

DROP TABLE IF EXISTS `produit_visible_clients`;
CREATE TABLE IF NOT EXISTS `produit_visible_clients` (
  `PRO_ID` int(11) DEFAULT NULL,
  `PRO_LIBELLE` varchar(50) DEFAULT NULL,
  `PRO_DESCRIPTION` varchar(500) DEFAULT NULL,
  `PRO_PRIX_ACHAT` float DEFAULT NULL,
  `PRO_STOCK_PHYSIQUE` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `visibilité_stock`
--

DROP TABLE IF EXISTS `visibilité_stock`;
CREATE TABLE IF NOT EXISTS `visibilité_stock` (
  `PRO_ID` int(11) DEFAULT NULL,
  `PRO_REF` varchar(50) DEFAULT NULL,
  `PRO_STOCK_PHYSIQUE` int(11) DEFAULT NULL,
  `ALERTE` int(1) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la vue `commandefournisseurs`
--
DROP TABLE IF EXISTS `commandefournisseurs`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `commandefournisseurs`  AS  select `commande`.`COM_ID` AS `COM_ID`,`fournisseurs`.`FOU_REF` AS `FOU_REF`,`ligne_de_commande`.`LIG_QUANTITE` AS `LIG_QUANTITE`,`produits`.`PRO_REF` AS `PRO_REF` from ((((`commande` left join `ligne_de_commande` on((`commande`.`COM_ID` = `ligne_de_commande`.`LIG_ID`))) left join `produits` on((`produits`.`PRO_ID` = `ligne_de_commande`.`LIG_ID`))) left join `fournir` on((`fournir`.`FOU_ID` = `produits`.`PRO_ID`))) left join `fournisseurs` on((`fournir`.`FOU_ID` = `fournisseurs`.`FOU_ID`))) where (`commande`.`COM_ID` is not null) order by `ligne_de_commande`.`LIG_QUANTITE` ;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `categorie`
--
ALTER TABLE `categorie`
  ADD CONSTRAINT `FK_cat_cat_id` FOREIGN KEY (`Cat_cat_id`) REFERENCES `categorie` (`CAT_ID`),
  ADD CONSTRAINT `FK_per_id` FOREIGN KEY (`PER_ID`) REFERENCES `categorie` (`CAT_ID`);

--
-- Contraintes pour la table `clients`
--
ALTER TABLE `clients`
  ADD CONSTRAINT `FK_per_id3` FOREIGN KEY (`PER_ID`) REFERENCES `clients` (`CLI_ID`);

--
-- Contraintes pour la table `commande`
--
ALTER TABLE `commande`
  ADD CONSTRAINT `FK_cli_id` FOREIGN KEY (`CLI_ID`) REFERENCES `commande` (`COM_ID`),
  ADD CONSTRAINT `FK_per_id2` FOREIGN KEY (`PER_ID`) REFERENCES `commande` (`COM_ID`);

--
-- Contraintes pour la table `ligne_de_commande`
--
ALTER TABLE `ligne_de_commande`
  ADD CONSTRAINT `FK_com_id` FOREIGN KEY (`COM_ID`) REFERENCES `ligne_de_commande` (`LIG_ID`),
  ADD CONSTRAINT `FK_pro_id2` FOREIGN KEY (`PRO_ID`) REFERENCES `ligne_de_commande` (`LIG_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
