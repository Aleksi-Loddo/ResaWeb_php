-- phpMyAdmin SQL Dump
-- version 5.2.1deb1+deb12u1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 02, 2025 at 02:37 PM
-- Server version: 10.11.11-MariaDB-0+deb12u1-log
-- PHP Version: 8.2.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `e22501948_db2`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`e22501948sql`@`%` PROCEDURE `generate_reservations_unique` ()   BEGIN
    DECLARE v_date DATE;
    DECLARE end_date DATE;
    DECLARE v_rsc_id INT;
    DECLARE v_salle INT;
    DECLARE new_res INT;
    DECLARE chosen_user INT;
    DECLARE nb_participants INT;
    DECLARE attempt INT;

    DECLARE done INT DEFAULT 0;

    -- curseur ressources
    DECLARE cur CURSOR FOR SELECT rsc_id, rsc_salleid FROM t_ressource_rsc;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SET v_date = '2025-11-17';
    SET end_date = '2026-02-19';

    WHILE v_date <= end_date DO

        IF DAYOFWEEK(v_date) BETWEEN 2 AND 6 THEN   -- du lundi au vendredi

            OPEN cur;

            read_loop: LOOP
                FETCH cur INTO v_rsc_id, v_salle;
                IF done = 1 THEN
                    LEAVE read_loop;
                END IF;

                -- Créneau matin
                INSERT INTO t_reservation_res (res_datereservation, res_lieu, res_heuredebut, res_bilanreservation, rsc_id)
                VALUES (v_date, CONCAT('Salle ', v_salle), CONCAT(v_date, ' 09:00:00'), 'RAS', v_rsc_id);

                SET new_res = LAST_INSERT_ID();

                -- responsable
                SET attempt = 0;
                find_resp: LOOP
                    SET chosen_user = FLOOR(1 + RAND() * 200);

                    IF is_user_available(chosen_user, v_date, CONCAT(v_date, ' 09:00:00')) THEN
                        INSERT INTO t_reserver_rsv (com_id, res_id, rsv_role, rsv_dateinscription)
                        VALUES (chosen_user, new_res, 'A', v_date);
                        LEAVE find_resp;
                    END IF;

                    SET attempt = attempt + 1;
                    IF attempt > 300 THEN LEAVE find_resp; END IF;
                END LOOP;

                -- autres participants
                SET nb_participants = FLOOR(3 + RAND()*4); -- entre 3 et 6

                participant_loop:WHILE nb_participants > 0 DO
                    SET attempt = 0;
                    find_user: LOOP
                        SET chosen_user = FLOOR(1 + RAND()*200);

                        IF is_user_available(chosen_user, v_date, CONCAT(v_date, ' 09:00:00')) THEN
                            INSERT INTO t_reserver_rsv (com_id, res_id, rsv_role, rsv_dateinscription)
                            VALUES (chosen_user, new_res, 'P', v_date);
                            SET nb_participants = nb_participants - 1;
                            LEAVE find_user;
                        END IF;

                        SET attempt = attempt + 1;
                        IF attempt > 200 THEN LEAVE find_user; END IF;
                    END LOOP;
                END WHILE;

                -- Créneau après-midi (14:00)
                INSERT INTO t_reservation_res (res_datereservation, res_lieu, res_heuredebut, res_bilanreservation, rsc_id)
                VALUES (v_date, CONCAT('Salle ', v_salle), CONCAT(v_date, ' 14:00:00'), 'RAS', v_rsc_id);

                SET new_res = LAST_INSERT_ID();

                -- responsable
                SET attempt = 0;
                find_resp2: LOOP
                    SET chosen_user = FLOOR(1 + RAND()*200);

                    IF is_user_available(chosen_user, v_date, CONCAT(v_date, ' 14:00:00')) THEN
                        INSERT INTO t_reserver_rsv VALUES (chosen_user, new_res, 'A', v_date);
                        LEAVE find_resp2;
                    END IF;

                    SET attempt = attempt + 1;
                    IF attempt > 300 THEN LEAVE find_resp2; END IF;
                END LOOP;

                -- participants
                SET nb_participants = FLOOR(3 + RAND()*4);

                participant_loop2:WHILE nb_participants > 0 DO
                    SET attempt = 0;
                    find_user2: LOOP
                        SET chosen_user = FLOOR(1 + RAND()*200);

                        IF is_user_available(chosen_user, v_date, CONCAT(v_date, ' 14:00:00')) THEN
                            INSERT INTO t_reserver_rsv VALUES (chosen_user, new_res, 'P', v_date);
                            SET nb_participants = nb_participants - 1;
                            LEAVE find_user2;
                        END IF;

                        SET attempt = attempt + 1;
                        IF attempt > 200 THEN LEAVE find_user2; END IF;
                    END LOOP;
                END WHILE;

                -- Créneau soir (18:00)
                INSERT INTO t_reservation_res (res_datereservation, res_lieu, res_heuredebut, res_bilanreservation, rsc_id)
                VALUES (v_date, CONCAT('Salle ', v_salle), CONCAT(v_date, ' 18:00:00'), 'RAS', v_rsc_id);

                SET new_res = LAST_INSERT_ID();

                -- responsable
                SET attempt = 0;
                find_resp3: LOOP
                    SET chosen_user = FLOOR(1 + RAND()*200);

                    IF is_user_available(chosen_user, v_date, CONCAT(v_date, ' 18:00:00')) THEN
                        INSERT INTO t_reserver_rsv VALUES (chosen_user, new_res, 'A', v_date);
                        LEAVE find_resp3;
                    END IF;

                    SET attempt = attempt + 1;
                    IF attempt > 300 THEN LEAVE find_resp3; END IF;
                END LOOP;

                -- participants
                SET nb_participants = FLOOR(3 + RAND()*4);

                participant_loop3:WHILE nb_participants > 0 DO
                    SET attempt = 0;

                    find_user3: LOOP
                        SET chosen_user = FLOOR(1 + RAND()*200);

                        IF is_user_available(chosen_user, v_date, CONCAT(v_date, ' 18:00:00')) THEN
                            INSERT INTO t_reserver_rsv VALUES (chosen_user, new_res, 'P', v_date);
                            SET nb_participants = nb_participants - 1;
                            LEAVE find_user3;
                        END IF;

                        SET attempt = attempt + 1;
                        IF attempt > 200 THEN LEAVE find_user3; END IF;
                    END LOOP;
                END WHILE;

            END LOOP;   -- fin lecture des salles

            CLOSE cur;

        END IF;

        SET v_date = DATE_ADD(v_date, INTERVAL 1 DAY);

    END WHILE;

END$$

CREATE DEFINER=`e22501948sql`@`%` PROCEDURE `p_reservations_by_date` (IN `d` DATE)   BEGIN
   SELECT 
        r.res_id,
        rc.rsc_salleid AS salle,
        r.res_datereservation,
        r.res_heuredebut,
        
        -- Responsable
        resp.com_pseudo AS responsable,
        
        -- Liste unique des participants
        GROUP_CONCAT(DISTINCT u.com_pseudo ORDER BY u.com_pseudo SEPARATOR ', ') AS participants

   FROM t_reservation_res r
   JOIN t_ressource_rsc rc ON rc.rsc_id = r.rsc_id

   -- Participants
   LEFT JOIN t_reserver_rsv rv  ON rv.res_id = r.res_id
   LEFT JOIN t_compte_com  u    ON u.com_id  = rv.com_id

   -- Responsable (rsv_role = 'A')
   LEFT JOIN t_reserver_rsv rv_resp ON rv_resp.res_id   = r.res_id
                                    AND rv_resp.rsv_role = 'A'
   LEFT JOIN t_compte_com  resp    ON resp.com_id       = rv_resp.com_id

   WHERE DATE(r.res_datereservation) = d

   GROUP BY r.res_id
   ORDER BY rc.rsc_salleid, r.res_heuredebut;
END$$

CREATE DEFINER=`e22501948sql`@`%` PROCEDURE `reunion_document_cree_modif` (IN `id_reunion` INT)   BEGIN

    DECLARE nb_participant INT DEFAULT 0;
    DECLARE nom_reunion VARCHAR(120); 
    DECLARE doc_existe INT DEFAULT 0;

     SELECT nb_participant_reunion(id_reunion) INTO nb_participant;

    IF  (nb_participant  != -1) THEN -- moins de deux participant

        SELECT reu_reunion INTO nom_reunion FROM t_reunion_reu WHERE reu_id = id_reunion;

        SELECT COUNT(*) INTO doc_existe FROM t_document_doc WHERE reu_id = id_reunion;

        IF (doc_existe = 0 )THEN
           
            INSERT INTO t_document_doc (doc_intitule, doc_urlfichier, reu_id)
                VALUES (CONCAT('CR_', nom_reunion, '_', nb_participant,'_participent'),
                'CR_en_attente', id_reunion);
        ELSE 
            UPDATE t_document_doc
                SET doc_intitule = CONCAT('CR_', nom_reunion, '_', nb_participant,'_participent') 
               WHERE reu_id = id_reunion;
           END IF;  
    END if;      
END$$

--
-- Functions
--
CREATE DEFINER=`e22501948sql`@`%` FUNCTION `f_salle_label` (`id` INT) RETURNS VARCHAR(50) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    RETURN CONCAT('Salle ', id);
END$$

CREATE DEFINER=`e22501948sql`@`%` FUNCTION `is_user_available` (`u_id` INT, `d` DATE, `h` DATETIME) RETURNS TINYINT(1) DETERMINISTIC BEGIN
    DECLARE c INT;

    SELECT COUNT(*)
    INTO c
    FROM t_reserver_rsv r
    JOIN t_reservation_res t ON t.res_id = r.res_id
    WHERE r.com_id = u_id
      AND t.res_datereservation = d
      AND t.res_heuredebut = h;

    RETURN (c = 0);
END$$

CREATE DEFINER=`e22501948sql`@`%` FUNCTION `meeting_email_list` (`id_reunion` INT) RETURNS VARCHAR(10000) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    DECLARE list_mail VARCHAR(10000) ;
    SELECT GROUP_CONCAT(pro_mail SEPARATOR ' |\n ') INTO list_mail FROM t_participer_par 
    JOIN t_profil_pro ON  t_profil_pro.com_id  = t_participer_par.com_id
    WHERE t_participer_par.reu_id = id_reunion;
    RETURN list_mail;
END$$

CREATE DEFINER=`e22501948sql`@`%` FUNCTION `nb_participant_reunion` (`id_reunion` INT) RETURNS INT(11)  BEGIN

    DECLARE nb_participant INT;

    IF (SELECT COUNT(*) FROM t_reunion_reu WHERE reu_id = id_reunion) = 0 THEN
        RETURN -1;
    ELSE   
        SELECT COUNT(*) INTO nb_participant
        FROM t_participer_par
        WHERE reu_id =  id_reunion;
        RETURN nb_participant;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `t_actualite_act`
--

CREATE TABLE `t_actualite_act` (
  `act_id` int(11) NOT NULL,
  `act_titre` varchar(72) NOT NULL,
  `act_description` varchar(72) NOT NULL,
  `act_contenue` varchar(256) NOT NULL,
  `act_datepublication` date NOT NULL,
  `act_etat` char(1) NOT NULL,
  `com_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `t_actualite_act`
--

INSERT INTO `t_actualite_act` (`act_id`, `act_titre`, `act_description`, `act_contenue`, `act_datepublication`, `act_etat`, `com_id`) VALUES
(1, 'Mise à jour', 'Maintenance programmée', 'Maintenance programmée le 2025-10-05', '2025-09-20', 'A', 1),
(2, 'Nouvelle salle', 'Ouverture salle 106', 'La salle 106 est opérationnelle', '2025-09-21', 'A', 2),
(3, 'Rappel AG', 'Rappel assemblée', 'Assemblée générale le 2025-10-15', '2025-09-25', 'A', 1),
(4, 'Ateliers découverte', 'Nouveaux ateliers', 'Des ateliers de découverte numérique seront organisés chaque mercredi après-midi. Ouverts à tous les niveaux.', '2025-11-10', 'A', 1),
(5, 'Nouveau système d’emprunt', 'Mise à jour du service', 'Le système d’emprunt de matériel informatique a été modernisé. Vous pouvez désormais réserver en ligne.', '2025-11-11', 'A', 2),
(6, 'Conférence sur la cybersécurité', 'Conférence publique', 'Une conférence sur la cybersécurité aura lieu le 2025-12-02 à 17h00. Entrée gratuite pour les membres inscrits.', '2025-11-12', 'A', 1),
(7, 'Nouveaux casiers disponibles', 'Ouverture de casiers', 'De nouveaux casiers sécurisés sont disponibles dans le bâtiment B. Vous pouvez en demander un à l’accueil.', '2025-11-14', 'D', 1),
(8, 'Mise à jour des horaires', 'Nouveaux horaires d’ouverture', 'Les horaires d’accueil changent à partir du 2025-11-20. L’établissement ouvrira désormais à 8h30.', '2025-11-15', 'D', 2),
(9, 'Concours photo', 'Lancement du concours', 'Un concours photo est ouvert jusqu’au 2025-12-10. Thème : “Votre vision du campus”.', '2025-11-16', 'D', 1);

-- --------------------------------------------------------

--
-- Table structure for table `t_compte_com`
--

CREATE TABLE `t_compte_com` (
  `com_id` int(11) NOT NULL,
  `com_pseudo` varchar(20) NOT NULL,
  `com_passwordhash` char(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `com_etat` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `t_compte_com`
--

INSERT INTO `t_compte_com` (`com_id`, `com_pseudo`, `com_passwordhash`, `com_etat`) VALUES
(1, 'pascal.emile', '2f80f697086799211b6a28eec4218cbbafcb578d3ffa98c6e20848a70d50f7ee', 1),
(2, 'girard.juliette', '037977b73cdd1412603d543efa715f08c649faa97d1ea2801cdbca09566059fb', 1),
(3, 'riviere.patrick', '08c7053ce34e52afa4bb3b18c2dc56961014d1257347bca23d1d11b41ba12fca', 1),
(4, 'breton.eleonore', '89bd17a96ad9fc11c910c6c7e9d2a9d64b77d77d4c5a17a241217d75390aa32a', 1),
(5, 'renard.dominique', '7682d5970d69625d927f2638adf6b85f4ff36dddab38f39156b5da561ec815a3', 1),
(6, 'gaudin.alice', 'e6c3da5b206634d7f3f3586d747ffdb36b5c675757b380c6a5fe5c570c714349', 1),
(7, 'gros.alain', '5fa81352d3dd69fd6f2238b9d26302884d386736a92c08103c82ba608abe7fc2', 1),
(8, 'gonzalez.denis', 'c334b58c420e3eea7f9bcf9c674f14d37e0fa4355249f56c920dea21cf80d295', 1),
(9, 'mercier.henri', 'fe31fa48a3da443d183749a11f4f350684d410f27938538c7a35def2a52c645d', 1),
(10, 'caron.clemence', 'e66610afdb8a5effdbf6f1dbcf8559ab4247ca51ebbba863c08539fd61c2d75e', 1),
(11, 'leger.maurice', '956f9dcb0baf61cd061e302b105be8198b642e11d4e10da020fcc219a38960f3', 1),
(12, 'toussaint.lucie', '7c99ba635f62de5763a5989c9325ccc2937cc3a3ed3a696b500f5b4c24660fe8', 1),
(13, 'valette.sebastien', 'c8fea5b0b76dc690feaf5544749f99b40e78e2a37c0e867a086696509416302a', 1),
(14, 'barre.pierre', '2d4589473fb3f4581d7452cd25182159d68d2a50056a0cce35a529b010e32f2b', 1),
(15, 'remy.josephine', 'b35892cb8b089e03e4420b94df688122a2b76d4ad0f8b94ad20808bb029e48a5', 1),
(16, 'caron.georges', '8057f787ebd8b4f9d40f53d7fbbfcbdde7067c1a074435b68f525b3de0e2ac2b', 1),
(17, 'klein.anais', 'fdac810d0c09f25c5ddcee9976ab1f1ae1973dba7c65152d95b0937bc2a6c883', 1),
(18, 'vallee.patricia', '1e53de2a2b4ab888cc24002ef8832d433b21956ab83ddeef989c8224b5c8f9f2', 1),
(19, 'verdier.michelle', 'b78f24953963ac5ed773d6ec83120e3b1a65510201dc09ed2ed9e9781ba88870', 1),
(20, 'gay.arthur', 'b5a4ec869015095060b1171791334513f741177c4011e2c5c36e3e37a5ff8e5f', 1),
(21, 'delaunay.renee', 'f0c28ba3fd9e0dcdcd0470acfcb98cc5a58d7d93422dbbefb930455ef714c87d', 1),
(22, 'prevost.gregoire', '4a6b7fa040bcfc734a113fee84d3789c0a626d70d029afad0d1c3e7b6c562e14', 1),
(23, 'maurice.nicole', 'b99ddd77e59c96b13b64b3abe1902db4c0a76dabf8622aa6c71f8f5670be6625', 1),
(24, 'vallee.georges', '871431053023291d24b403f1f9d761c6f01b3050a0a83cd9d9759a970f8d4d92', 1),
(25, 'charrier.gilbert', '51d11024031a8951b4722671adfc8587538f5e5417206e7862e60752758a5c35', 1),
(26, 'torres.nicolas', '2d6b3bb57cb9e22fa36516172ef096b30ae00d08eedc1499c599b6269975521d', 1),
(27, 'royer.sylvie', 'd0f82756c4d40d20e1fdbc90cf4da4adff02fe23b355687525880514642f764e', 1),
(28, 'pruvost.helene', '8893186d24cce07e1c82f2e020d41177e699318b4be9535483fdf55edf58cd50', 1),
(29, 'rousseau.anais', 'cafdc894eacc597ad76db1a750ccb876d4ed69c73b7d3d23f5e3a9e3b5c9fc2e', 1),
(30, 'rolland.daniel', '0028e1c0d2c60966390545414567d33bca9f0165fece6d0109c59a3f29b5fdd0', 1),
(31, 'devaux.cecile', '45e17065ddc6fb3a682f7732df5804652952dbe1f5ca5377a661515a8fcf66be', 1),
(32, 'georges.maggie', '43b3ec9ea3961a319d37b4cc775d3f43f68709b62a93db10dd6c598137f28732', 1),
(33, 'lambert.joseph', '034a0cdf079dfa3ca924e07e3c509bbf50768d1949b021c0ea0030cff80ba4d1', 1),
(34, 'le.goff.jeanne', '53f6f072e26d36b9e55d5dc828872856d5286f18ce3818d367f9e4473e464a66', 1),
(35, 'salmon.therese', '85fcbe6bf830f23209ea6a932921e8da31a653a24a20cb84e75c4997e505690b', 1),
(36, 'prevost.alain', '3b3ad733c8571384c133694595c33d96c638b36f08a484bd0ad38bf312fdb294', 1),
(37, 'laurent.marcel', '451a8149ebd58dbd064e3337c6de5d4f4bb08cd70bbbd48d62a205bd706b6bb0', 1),
(38, 'guichard.gerard', '0756810289814362efbea8bb826fea0a7bc4318a7f22a4b27b48290cd39951a3', 1),
(39, 'bruneau.aurelie', '94cd5db06baf087fd56c0042adc1deb162d271acfb8b3eb0277069517998d489', 1),
(40, 'leger.jules', '5a66c7ba1398dd71c92a77cc7647c4183e6bf97b227e441bb2674a319b184e63', 1),
(41, 'turpin.ines', '133f8a05107e5442771c85da3dec70050ae5f3273849326b4a4e2ceaab2ef058', 1),
(42, 'dubois.louis', '1a31ac086ebf1341c916929e6d982767cd8568887d7c930ba8abd062afa08eac', 1),
(43, 'marechal.bertrand', 'b64171fda74426604480b9bf7c10ccdc2ebc80266c8667c42346f54ce87d4dec', 1),
(44, 'brun.margaud', '099646084abbbc2c403c480bea87e7de23ce18db73a3e28251effef3ed49f1ea', 1),
(45, 'techer.clemence', 'd88a53cd8ffe65ab18d2c62882479559aa781642ce7a8d340b22fc0a637b0359', 1),
(46, 'maurice.hugues', 'a8a5146b1f97c2c8987ccb3a87d2f30b8aa258c2a32cb96115bf381d42df875c', 1),
(47, 'mace.josette', 'de3543c757d459090b9adaf9a80a54d54724a0f1600d4c77d6017dde58cf1189', 1),
(48, 'raynaud.leon', 'db9aa0719dbf5cac40e44b268042014e9bc28b4134df9051a35f8c64f6603b6f', 1),
(49, 'lagarde.marcel', '147eb7dd0f4c59120be8adb20f9dc4d4a0ccb27a0d48d7546dfa171dd980f075', 1),
(50, 'dumont.honore', '64bf83fcf172a284e3db6b4cc76bb175184ee9dd57e77f0421e3e401ea3858e0', 1),
(51, 'colas.philippe', '3f1b954c84d8216e09ae793664571dedb1e1bcc9a2bfdc2b6dc58db9a24fa7de', 1),
(52, 'boulanger.gabriel', 'dbb70b94b6b192a1085e8056872daa4eb24002d47c82e88b1323f1a5882567ba', 1),
(53, 'breton.laurence', 'ffe4daf45af0e803fbe1fba2de5c7f7644f30b71ddb082100779d7884e0291c2', 1),
(54, 'imbert.marine', 'a0c69ae7ad7629347d41a89d9a558b26bd9b126a3a183f3498444843acd7270d', 1),
(55, 'marin.pauline', 'be46e03449534372e45f1abf511f78148625cf11d99f2f550e2f32b3a551dfb6', 1),
(56, 'barbe.suzanne', 'cc35e4b303c84633f2e64c1fe30a9c2f9e0f1dcdd53d1a748451b83164db475a', 1),
(57, 'ferrand.colette', 'f511f615cd867553edd2fc66f4dc34441851f699cc1457f767c5ec0bad8cd250', 1),
(58, 'chauvet.emmanuel', 'f75b853a4521962ca5d349e4ca4cb69dce2dbfef61731cb9d14f1f2f1b6499fe', 1),
(59, 'maillot.anne', 'db383db8666c1c7f372e49b801a0405e0dd4193ab772163521b16e78879fa334', 1),
(60, 'barre.elisabeth', 'd6f7adababfd90706cc787591cdaf547f91d53abcb9008a180d90fc3d4f651e2', 1),
(61, 'marie.robert', 'bacb5d03bee1af445b7cc73ba8db52a7fc01d474327c87899831ffe3b4c3543b', 1),
(62, 'allard.remy', '3b356cdbaeb3d03a6b6f713a048489d62fd63b4a8fd0c70a976cb0b70c119e46', 1),
(63, 'maury.denis', 'daa7c4bc3f1506b52b2bcc7864db9a96aee3ec1a8a68b29c5db60de1f8a6918b', 1),
(64, 'techer.nicolas', 'e5e0e771c99778aef6f0046adb86a3d3e3ede2c68f43aae6b4ee9d498709328b', 1),
(65, 'menard.lorraine', '598ed9422e3d9c328f48cafc2c66a66a3d393b64290f7741d60e6e22c03ca031', 1),
(66, 'blot.timothee', 'da3df0f1c138cc7b9e79e218587a605e12b7a9b9ac24e1287da5ed056cf10c22', 1),
(67, 'maury.lucas', '9b857dc1d1dc03b131bdb429b972f5f28c7d72b8466a22d54c359c48d19551fe', 1),
(68, 'daniel.marc', '7e251ea07d59cd5fc9d7d1dc4225104e474b93d6c6881797dfbfa010774d4acb', 1),
(69, 'david.thomas', '51031e17ce0a58242bf97f01a2883d077c6dd21f22674ee500dbfb60228851e7', 1),
(70, 'fleury.joseph', '3c62426f46ebb414ff53540c6f1af32639c28b434126ae98b9f1651dd5e4fd4a', 1),
(71, 'ramos.alain', '06599c96e52ff54f21e65cec89df4b96ce519704136d6f7246a56be613eed8fb', 1),
(72, 'bernier.amelie', '8a110e75a8142ab756babe02160548ed6c254ae3fd931b297aa4edba91065732', 1),
(73, 'delattre.catherine', '5a583fab00aa1c17acaad80b2b9b5a16a8563e7e66808bf4b4acbfb55d9b85d4', 1),
(74, 'nguyen.valerie', '667d45d6d55c4fe6a7239bb554854e3b8fc0b392abea73864e91104bb1b4581d', 1),
(75, 'aubry.bernadette', '44b6dadf9835ff29d5342da14dfaf76e3d828081a1704b131baa355f950e6047', 1),
(76, 'huet.guy', 'a06afaf373a81a1bcd1641fdd0f8b9c2c0d7104171abafbd80d11e933a9c6a13', 1),
(77, 'coulon.victoire', '79db1e22563af60be55a3717827926b76139d2428cbe693eba1643c2798e048d', 1),
(78, 'pelletier.edouard', '25ac9b17f8113ceda4e3b18b639ac0c5821fa6cf61e31a4b2cafec4573b89522', 1),
(79, 'vallee.frederique', 'efacf97ed63d8d618e5c1f03e2fbd3656ed4c97ba04abf6db791534b425641c2', 1),
(80, 'deschamps.aimee', 'aaa88f12093ddca8064cdb97bf7635d7cd82c94d264121133f79f24e9b645bf1', 1),
(81, 'chauvet.leon', '55e315face2c7bcfc4b1d43be3a863e3bbb565ad3dafe30a9dd45b51b190be9d', 1),
(82, 'verdier.capucine', '2590d18604c282ff195459db33d0ae2caab98b14d4cbfdfd4dc3ed4923bf31b8', 1),
(83, 'briand.mathilde', '70dfb731f9ecfb0c9015b28838281e2a3cde900a791c45532154ddb5a95ed31b', 1),
(84, 'blin.helene', 'f46c534ea1cb330122334be00303592a10bcbbc238d1b11e1b498d4486d13755', 1),
(85, 'martins.bernard', 'a5276c24114971eceb4d5149894034741bcf22825b30c39942ff63007e031956', 1),
(86, 'guyon.theodore', '7137bc5132a11c4937a830c4f594a551b18d0764f66f8478de3db48377f2b611', 1),
(87, 'riou.clemence', 'ca619acdadd8eb0f598c954031b5f359a2fbd4fe0179eb02acfeab2ad373c999', 1),
(88, 'benard.honore', 'dd76076f40644e9e57f7459bfc37b2ef8b7084bda5a3127c24a62c86dd45eb0b', 1),
(89, 'blanchard.robert', '11ee91bdbb90b967d18e45226bd3bc17d72a85a4486315b3568d070722445fe1', 1),
(90, 'potier.jacques', 'cfecdf5846f8e8279f4dcf79a2135308e11c0d283175a2fb79b33b76f487cb24', 1),
(91, 'legrand.adrien', '3c0c8e2f0527574ed275f4fc831af606b283370490f9c39c7389fb5d16dd6ac8', 1),
(92, 'dos.santos.denis', '4a2efe616f41f27f583d7e1e628a7b019f2b2603677ae0216d14559eefb83975', 1),
(93, 'poulain.genevieve', '1d45a36925bcb8f729f8f06ee0ec689f440cc6b08c3a0573ed12e10104e1e9a0', 1),
(94, 'girard.francoise', '9d57ee06aac896609727855add2cfc3d9c50cd545395974cdee219c91e29fd25', 1),
(95, 'gregoire.bertrand', 'a4273f882cab7a89e7fa8e5a1298799b62233ada8a93f880f58bbd87db44d6a3', 1),
(96, 'jacquet.bernadette', '7f6ceca338f7fe1bb409870c95cbf5009115df953af77a91ef912a11cf6423c7', 1),
(97, 'berger.celine', '905026a6ddab21a9d1dca17cc4f47b843eccd1c4806f7f3c59b88cdac12e339f', 1),
(98, 'lemaitre.paulette', '3dcc4d43a91ae471be9fb0dfb7e7a44dcbaf8125b389d65d38604ec5582825ec', 1),
(99, 'hardy.alix', '3fdd6e2fcae488c7c7818992ad08249cd0f6576f6ff846bcecaa816e002cde3c', 1),
(100, 'gonzalez.benjamin', 'b3f20ff60a6e1eda26f8c412e7173c7ee7f5b3a1124b87a38d3deb63274c1a61', 1),
(101, 'jacques.nicolas', '38ee64c8e2536e41e2543266f6a5216747b24c8b8ada7d5f7cfba8b1e80752fb', 1),
(102, 'jean.marie', '7f5106053c87018f57187a0a485dedacb2ef37f08f05ab2313f23217a9ee928b', 1),
(103, 'boulanger.patricia', '125e175312b42ca54475207f1ad47df9ac421dd758fcc5c2ab19ae31e451cc53', 1),
(104, 'labbe.elodie', 'ab2f50fe825bc3a9a8b649f173af23be3a052db9b410fcb0127e50ae9c356ba7', 1),
(105, 'lecomte.yves', '29bf72f8d89f83e2fca11f01a530b0c39058b8fd0b0563aca173d2c624c71ffb', 1),
(106, 'olivier.claudine', '2bd2a833384945be5a4d05109f418acbc78cc41d7640842f0e881ba892651296', 1),
(107, 'perret.bertrand', '68b5aa742a3c02d41ca5c6582f9eb685ae72218e0c93680f91d51086d45e67df', 1),
(108, 'imbert.denis', '9e436b2455b7d1b818d56b04b8985d84ac27e7fb45630e579f7b0695430fbab5', 1),
(109, 'lemoine.alain', '34158b36b0dccb351ad920cf5ebb74820d7825119c647b16db4f535bfef25c65', 1),
(110, 'cordier.valentine', 'acb3085ac0fa0ce03af7e46da8e5ac3bbb2c03d6a28cfa95c778daa5d525412b', 1),
(111, 'barre.nicolas', 'd0f775036f29ba7540be994605826ab25b7f153a1d8157e5e09218b8fa59aa91', 1),
(112, 'garcia.laurence', '225adbca5f1445b65f065079fd6b3fdda829b6e660554b6200e86fe4a129672e', 1),
(113, 'maillot.helene', '02548935a13223836dc0fdfa7574d4adc6bd5b60a99296cc54cefe1e7103fbcd', 1),
(114, 'dufour.margot', 'cf78821e30a469451bbb37eb5bd9976ea68d77ea3dd54ac3dfd83de5cf91eba5', 1),
(115, 'roy.juliette', '8f3b97e5c348a48d4cde1cf58b7746221cc4f23b1471cb7b530a4e4b7ac5b887', 1),
(116, 'huet.lucie', 'b2c56341cc2b9f8bf898bd7528dd39e641b51c4fbd51f241b46ad70872dd1b99', 1),
(117, 'dumas.noel', 'a1f5626f394c753975a9060627b1894e2c82436d7d9fb6103f58455641771682', 1),
(118, 'ferrand.elodie', 'd2d8fdd3e123c147ca908c7fec41c7fe5746e7cc1b90e3507859ab0a7a0212d1', 1),
(119, 'guillaume.marcelle', '6a4ca776c3ef0c0d69107200ff1ff66217511aab72e032962fb5d6c01aabb158', 1),
(120, 'david.maurice', '62fbf022ff434c1cf42eed2a12c109388af61ea661a1cf75e8a16b45f0063c77', 1),
(121, 'launay.alice', '747ff88fd5750ff3ff02e7b5bd02508eb0c9dbaee5bb5d472fc9393878c8a733', 1),
(122, 'payet.georges', '96a194c82bf3b9e984cf3740c3a29632c9f2ac55a35d46a5c719c6ff65823d24', 1),
(123, 'mallet.victoire', 'b48166b6083b5cc4becda5bf00282abf57c1166b1d4e9c65f59be95659320e39', 1),
(124, 'duval.theophile', '3f5a78fdff13749416cd1f00e6919427a387c843f78e3fe11dda1f471198276e', 1),
(125, 'blanchet.therese', '8fca772f847cd309ee9f795d10aa141ac4bef4d87f4b80272e2573cd51010ea1', 1),
(126, 'gay.josephine', '3fe239dfb6207aa4e467245cabc3a8221e5f15f0414b3b60371efe7a05aaf1b4', 1),
(127, 'renard.laure', '882363cd1c89dc3169b92a33947bb42ad60e975b8a4d177989c6ae2f013de721', 1),
(128, 'delmas.hugues', '9b8769a4a742959a2d0298c36fb70623f2dfacda8436237df08d8dfd5b37374c', 1),
(129, 'brunet.emile', '67da66db02bbd90735c73e948bd5b8222a60a884554b217eb066f89b70c264e8', 1),
(130, 'godard.guillaume', '51e126a6e7bdec24c7e7b07e1c86c5fd6d1fc674ed560c5b2133335384a54c95', 1),
(131, 'bertin.francoise', '94fdd9e803f50ad10e634eed483d01f83db8326aa393a68cedb6e2d32c996ade', 1),
(132, 'lefevre.virginie', 'b2aa39291446250a4963b308653abb9fc746c72777759f3e6708fa6cf8fb1900', 1),
(133, 'collet.bernard', 'c9148c9fd5a65e12b6d924efdba0f36195c78b9c1c7cdd4755817daf32dc174f', 1),
(134, 'fernandes.guy', '2a8eccf0310f27a038297a74b99fe76a7887ce332d8f73610cab88f5e8fac637', 1),
(135, 'chretien.julien', '6f3c808b0c349bf9310731e29aae8beb5c978a73878e4d3cdc5c7b7e7423bb18', 1),
(136, 'pons.odette', 'c1d095050623a101f1be6e2da08f4da86227310fb360dc566551de880efc22e3', 1),
(137, 'perret.marc', '309379267483b31fea2fa71be956c1b5992f9107ae601d46e15275152e293f35', 1),
(138, 'jacob.honore', 'b842b6339c1900efb74f09fd8dc048bb50c1e7bcb179964ed31207c0e9c7decc', 1),
(139, 'noel.susan', '2e8f49f90946f2de44e4e900d85ad1da5887c5feaff24e467f06742ffeab686b', 1),
(140, 'dupuy.thibault', '9b1b6a52450435b5c61acfc1765542d8bb8d4e023327b2a87827fb89cab2bff3', 1),
(141, 'da.costa.virginie', '4450bf0c02623f832c7f7f93fc067f085bc95162d345fe1e95e640b294735e0a', 1),
(142, 'david.victor', '00f78aff5b35171a4a10ac9bad5eccc121ac4e678cb74bab0e71bfb972ab7ad6', 1),
(143, 'ferreira.nathalie', 'bc647ef28b901e09e8b5c373eca43ba2c64611247d70ecc973dbbfa49a385e53', 1),
(144, 'guillet.denise', 'b883dc59e83d063f0ad1c5fc917d5c95df10349c2a5eaa0054d40448d0e30261', 1),
(145, 'poirier.christine', 'c5585b8e6481359e9115ee634e6e7d347fdd2cce19c36a450f388643d8fbf3d9', 1),
(146, 'lemoine.martine', 'cd75d9010f6f120a32361ba9e26396fdab2f2122602fabe818321f42f09f5d20', 1),
(147, 'richard.patrick', 'b2db914133c89e6a0798c08136a40e0810b869816c44aab5f2c98f4bd210eac3', 1),
(148, 'martineau.bernard', 'c3b87469726089da03985e426738badfc40b00048c383caeb8784762a9c760dc', 1),
(149, 'delannoy.mathilde', '8a46261b0b1a264e19114bfa09c64b289dc93819d9978349177cbfc1c7098538', 1),
(150, 'maury.dominique', '0738f94c476bddc7e78c286ebe8836875e9a247b192badf4a1cda2307be6861f', 1),
(151, 'bailly.zoe', '2b9a57088cbdf4386bafedc5a3653538613587198532c24e7a40da3208150a77', 1),
(152, 'lemonnier.aurore', '7a6ae0b891d5473f1d239c21d41bbf01c9fb3c9e9f6579fda796053d8406e40f', 1),
(153, 'robin.francois', '228410cc8b122eb4ad2d8ec3b82a98e9f931ffd51f4b6d4631b44d38b0ba17cf', 1),
(154, 'perez.celine', '8518dd4530c31281599093e6ff42f50024e516ed208eda80c8fef6214d0c5036', 1),
(155, 'maillot.marguerite', '963f65f9d1a9bf30cf2102f2e6efcff7c9899537acc7831ce5270616052839ef', 1),
(156, 'vidal.eric', 'b9d7319cf037dc2cd01704356fe3671b449829653c56e8c93ef37d5189eaa655', 1),
(157, 'mercier.louise', 'e9488e9209629f0b61ba2f2cac89bc4741bd4fb21d3e408a012bcdb7a8cf7950', 1),
(158, 'peltier.isabelle', '5419cfef2fdf2c0e240adc340b7930d43857389e775c5fb2cc36980b8521f2ce', 1),
(159, 'blanchet.josette', 'cd16fa43071d6cfa25884d2caced1ce52efa59b92dfc99ab836813fc5e69db03', 1),
(160, 'lemoine.helene', 'f1d4adbad69cc4f1271b9c9682db410a1741300d5ccc632f90faeadc8b934e66', 1),
(161, 'collin.amelie', 'b90397a77e0f5216feffa1392c9aea5d1cec0f513d237726725db4beaab4c79d', 1),
(162, 'mallet.theodore', '67977a0a44852851c4b5f8efa40815f304e1bb4648c0ff0412ba9d420b6f6934', 1),
(163, 'pineau.arthur', 'da8977c150aeb01f6fd84d48fa7d2e4807bdd3512e03b9e9dff854de3094f970', 1),
(164, 'louis.aurelie', '444420659b079015d309e33d983c0466134da01b5884c18f6dacea3eae98ef82', 1),
(165, 'thibault.auguste', '00c1956e5d6c5de46388b9875730b0afa1d3107c9d1c9ac1dc072e1763c93f06', 1),
(166, 'teixeira.paulette', '1971d8d564c23ec092839d6ea9fd36deecc0451a437d368fdf22b9ec4e6b92e5', 1),
(167, 'roger.valentine', 'ce0cc5d6aa577f8b966b4d738a85522a641734b4cd0eb96fac1fb149f32007a7', 1),
(168, 'ferrand.capucine', '14970d5553628849705c327b02159358c048af6b5b3d10154cb21436d6cfd84e', 1),
(169, 'fernandez.laurence', '4f40d5ea6bba1e84c6f18448cd1a7a316fc31b82c616843a4f312d2931734bc8', 1),
(170, 'mace.julie', 'd185f2b0f80fa3187ced69ddd858127703af6ada6c73188921e71ecec29e3b86', 1),
(171, 'duhamel.rene', 'c40832c56bc9882a6972a3aeee7beaa56bbfd68f2476800f01fac3027f886e41', 1),
(172, 'costa.michel', 'f119146b406bd7b72461cc675b8a61e9e082e7e124f6e944a982547c8a847023', 1),
(173, 'gros.marguerite', '5cba853b36ccafb52b3ad11d0c218dcff589c9168218c620a18fa094ebfa3ffe', 1),
(174, 'auger.gerard', '4af8d9659200e8d30d8a056a14b3eae088d64dd151fcff72ffcf3d08cc9b7977', 1),
(175, 'guilbert.guillaume', 'f08c71d147cc34f4b144866232758aa35238d29f336aaa8f89c76408c1cf16fd', 1),
(176, 'maillet.aurelie', 'a8e746a7f23319a9f705297e700980fd003907151770b570200bd74693ffc945', 1),
(177, 'blin.claudine', '4e198562e9846d7db9edd6cf77fdff9330db7a23279d6d04ffcbc1c02680ecdd', 1),
(178, 'lopez.denis', 'd20ffef6f9b9969c6a99eb65268a0d457f1631195375a3fc9ea2757c82f1c267', 1),
(179, 'briand.anne', '3c970d58b00bbfbd11be99238412b8dc8c95392524057a7c79987502245bc813', 1),
(180, 'david.julien', '5aaf677bd8cfe27d494b927b5cd69431ddf92b3b037aac21889c432e5496bdb9', 1),
(181, 'martinez.aurelie', '104266cc04dadae9683358555fa193734617b15804913ef965c74773bdbd575a', 1),
(182, 'maury.josephine', '5cd72b9bba9a46617799dd18304322f82e0e66e9fa3fcd3da9cdcb995cfbeddf', 1),
(183, 'lebon.elodie', '956faeec27b882d8aa972d50bfa99b11ab6f7856f67ab9ffafbe1b66241ef4c7', 1),
(184, 'legrand.adelaide', '8e8225ca92553c420aea93fc2f8b5a143b9c9c1fc78f84e6a25dd18023aa7db3', 1),
(185, 'marion.philippe', '450bf5e97fa8f4f04d50d84ce7398963e5df9278226aa57c2988451a7274769e', 1),
(186, 'hoarau.susan', 'e60f65cdc15dc09ab7e182cb569c1e4296dad5eb9540e75542eb47492fc81e7d', 1),
(187, 'roche.caroline', '5a258638f0a176640f9bd9a0faa8daeb403b83fcdf2deb2d4686d2f05938c29b', 1),
(188, 'mathieu.marthe', '7714695bf057d6baa0e352409c96efd190286db4a2cbda4b2255937258fcb3ee', 1),
(189, 'gerard.chantal', 'a459eec8f81e241c105297bf0ace06d2810c5c0c3d2f6c30f624905396664f6d', 1),
(190, 'caron.marcel', 'deef99d335bbd310f5c6986922090e2ac487005ba1e84001a36f036652872b18', 1),
(191, 'gaudin.rene', '7dfb019cb9a337a188ddb4fee0b8e679c9d2479ac6b94c7c83bf9bd565d109ed', 1),
(192, 'navarro.alexandria', '1bf3064b71d17cdbe7a756d45913e9715e93f6dbdb470dabe37f4c9f1247fc6a', 1),
(193, 'godard.constance', '4de66ca94812977400f463080d0f81a0016dc5ce29f4778009f4f0d12f48643a', 1),
(194, 'lebrun.lucy', '1915ea8a41f31bdbb0b879253783585c0a001b84911f045bf150c4281cb54e6c', 1),
(195, 'laporte.lucie', '7759c9a5a8b5474b76c7b5c00b3c04d6ca6cdeabbbc52e25f9a54f2556e59c0d', 1),
(196, 'martel.william', '6d5b63fbb2a973497bdc9dc4a0c8010792bd51a8eb330491dc572e4bc2bf051b', 1),
(197, 'david.remy', '4a31314b88ab8c6b07d92caaa0e4a7005592b1428057fe9529a7453a19fdae85', 1),
(198, 'delorme.dominique', 'd99d67863f59e7edeba66002be4db1c98e286b60cfadbcb51698b17aa184b842', 1),
(199, 'lemaire.edith', 'e4c911e848bec00ba411ecd205d27b6491afb7ab09827d2e533715a144f5afd4', 1),
(200, 'grondin.emile', 'e3f983a118f5555062edb40c37e8b4530bfb87c6c89c76004dd3cec7126796b9', 1),
(201, 'jean.sebastien', '45bd6b371d1011e47bb740399a7e081a7fcf9b75658a59407ece7badca23c34f', 1),
(202, 'joseph.elodie', 'f0ce3dcabde8d6c2bb2db2f4855722a0de8086f0d25e938faf19242bf1cdd730', 1),
(203, 'jourdan.gabrielle', '409531cd7d31812ab58a30b6b8eb25642cf68dc4c8929a100b231f70553a4d42', 1),
(204, 'ferreira.bernadette', '0eaa0730cc0ee0f8c888a00450006d514664d528688c87cf42047f0269e1aa3d', 1),
(205, 'mace.auguste', '311514b6345cd997bdb96acb5da71813c1f086ac3ee3319d74a0ef5e92555f33', 1),
(206, 'invite1', 'e653119e43df0a110d67263e0ef72a3eb2c8c78e1694ba1b3d50b1ea0eea315e', 0),
(207, 'invite2', '5822cb9479c8f39217ac527eaa60a7d6f865407daa8a4a593ad13f7e611bae50', 0),
(208, 'invite3', '6601eb69a44be6e0c8c3835fb40a825d699f43d901d219251a36137fb4cf8ac9', 0),
(209, 'invite4', '07436a24ebdce6a61c0e51cce921e58b1acbda901c3bce4cedcd8ae7858602a8', 0),
(210, 'invite5', 'd45376c8201bef2f2494c1a0c6cded1c85887d77e3cb7fedaaf472d76e513efd', 0),
(211, 'invite6', '3e56e0a8d21ce22f7ff639c584927397ebaf9367e8c9136e7ea172f0ca015096', 0),
(212, 'invite7', 'c91e2064dd1eed9db0a0b19a6fa4fa92d2d61f003a53262cd24a73de80711317', 0),
(213, 'invite8', '22f5d9814fdc9603a0737c929b053b36779cdd1f3fae4cd46a6b20a3bf561a37', 0),
(214, 'invite9', '72a7d943cd57e7b0ff1edd3c1bfc55078bc483e63a2a492610a452234a098b3e', 0),
(215, 'invite10', 'f26d27e2dd74c73f947c3883fcd55c584cbbc67ec5cb1e04dfc275704254998d', 0),
(216, 'admin.dupont', '36104b746ecc130b6e627e5b924db865bf908fcc1b04f0d96b6a8d939e05387b', 1),
(220, 'inviter14', 'c833066e4293b2aa33846cd4d9bd6ecb35c9adf78067c7eb9d4006abf53a4894', 1),
(221, 'inviter15', '6e9e9e4eb6bc19ece801f5b4b9edc2e018024e09db5d2127c29c12f93cb76973', 1),
(227, 'inviter19', 'f2d91926ef648ffdf8993521242de8d2a8574f62078abb7554a3231e470f0beb', 1),
(228, 'inviter25', '8cdc24ba5ccab892b09281054062f2b32fb404d139cb987c0dc5f7d4a59941e4', 1),
(229, 'Testing', 'c10d433ba637c821573ff1dae6c4394e3d4c8a7ef18f30998d48602448e3864c', 1);

--
-- Triggers `t_compte_com`
--
DELIMITER $$
CREATE TRIGGER `hash_password_before_update` BEFORE UPDATE ON `t_compte_com` FOR EACH ROW BEGIN
    IF NEW.com_passwordhash <> OLD.com_passwordhash THEN
        SET NEW.com_passwordhash = SHA2(CONCAT('celaestmonsalt123', NEW.com_passwordhash), 256);
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_hash_password_before_insert` BEFORE INSERT ON `t_compte_com` FOR EACH ROW BEGIN
    SET NEW.com_passwordhash = SHA2(CONCAT('celaestmonsalt123', NEW.com_passwordhash), 256);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `t_document_doc`
--

CREATE TABLE `t_document_doc` (
  `doc_id` int(11) NOT NULL,
  `doc_intitule` varchar(134) NOT NULL,
  `doc_urlfichier` varchar(300) DEFAULT NULL,
  `reu_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `t_document_doc`
--

INSERT INTO `t_document_doc` (`doc_id`, `doc_intitule`, `doc_urlfichier`, `reu_id`) VALUES
(1, 'CR_Réunion Projet Alpha_2_participent', 'docs/plan_alpha.pdf', 1),
(2, 'Support atelier Beta', 'docs/support_beta.pdf', 2),
(3, 'Ordre du jour AG', 'docs/odj_gamma.pdf', 3),
(4, 'CR_Réunion_Test_Proc_4_participent', 'CR_en_attente', 4),
(5, 'Compte rendu du comité CR mis en ligne le 2025-10-09', NULL, 1);

--
-- Triggers `t_document_doc`
--
DELIMITER $$
CREATE TRIGGER `cr_mise_a_jour` BEFORE INSERT ON `t_document_doc` FOR EACH ROW BEGIN

DECLARE doc_int VARCHAR(134);
DECLARE msl VARCHAR(50);

 SET doc_int =New.doc_intitule;
 SET msl = ' CR mis en ligne le ';


SET NEW.doc_intitule = CONCAT(doc_int,msl,CURDATE());

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `t_indisponibilite_ids`
--

CREATE TABLE `t_indisponibilite_ids` (
  `ids_id` int(11) NOT NULL,
  `ids_etat` char(1) NOT NULL,
  `ids_datefin` datetime(1) NOT NULL,
  `ids_datedebut` datetime(1) NOT NULL,
  `rai_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `t_indisponibilite_ids`
--

INSERT INTO `t_indisponibilite_ids` (`ids_id`, `ids_etat`, `ids_datefin`, `ids_datedebut`, `rai_id`) VALUES
(1, 'A', '2025-10-05 12:00:00.0', '2025-10-05 08:00:00.0', 1),
(2, 'A', '2025-10-07 17:00:00.0', '2025-10-07 09:00:00.0', 2),
(3, 'B', '2025-11-30 00:00:00.0', '2025-11-01 00:00:00.0', 3),
(4, 'A', '2025-11-05 18:00:00.0', '2025-11-05 08:00:00.0', 1),
(5, 'A', '2026-01-12 18:00:00.0', '2026-01-10 08:00:00.0', 1),
(6, 'A', '2026-03-17 18:00:00.0', '2026-03-15 08:00:00.0', 2),
(7, 'A', '2026-04-22 18:00:00.0', '2026-04-20 08:00:00.0', 3),
(8, 'A', '2026-02-05 18:00:00.0', '2026-02-05 08:00:00.0', 1),
(9, 'B', '2026-02-07 17:00:00.0', '2026-02-07 09:00:00.0', 2),
(10, 'C', '2026-02-12 18:00:00.0', '2026-02-10 08:00:00.0', 3);

-- --------------------------------------------------------

--
-- Table structure for table `t_indisponible_ind`
--

CREATE TABLE `t_indisponible_ind` (
  `rsc_id` int(11) NOT NULL,
  `ids_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `t_indisponible_ind`
--

INSERT INTO `t_indisponible_ind` (`rsc_id`, `ids_id`) VALUES
(3, 3),
(3, 8),
(4, 9),
(10, 10);

-- --------------------------------------------------------

--
-- Table structure for table `t_messageinviter_mei`
--

CREATE TABLE `t_messageinviter_mei` (
  `mei_id` int(11) NOT NULL,
  `mei_email` varchar(200) NOT NULL,
  `mei_titre` varchar(100) NOT NULL,
  `mei_contenu` varchar(600) NOT NULL,
  `mei_datecreation` date NOT NULL,
  `mei_code` char(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `mei_reponse` varchar(600) DEFAULT NULL,
  `com_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `t_messageinviter_mei`
--

INSERT INTO `t_messageinviter_mei` (`mei_id`, `mei_email`, `mei_titre`, `mei_contenu`, `mei_datecreation`, `mei_code`, `mei_reponse`, `com_id`) VALUES
(1, 'guest1@example.com', 'Poésie si protéger neuf.', 'Commencement satisfaire trois.', '2025-09-11', '9F4L7AXYOEYZGCHNYG0D', 'Dernier former mon combat celui.', 157),
(2, 'guest2@example.com', 'Ci accomplir mode société.', 'Peser liberté clef appartenir.', '2025-09-12', 'B96EMMBOZ3W7BH8MNHPC', 'Prétendre oeuvre calme général quel même âme tomber.', 30),
(3, 'guest3@example.com', 'Double lier imaginer prouver son tant.', 'Debout achever existence aider.', '2025-09-13', 'I9XF3R2LU7283ZE1BVPW', 'Imaginer courir machine pluie entre monsieur entrée.', 59),
(4, 'guest4@example.com', 'Si nez non discours rocher ignorer.', 'Occuper impossible ciel côte public glace but.', '2025-09-14', '87TKRVSXE9JR8RJAW989', 'Air fin chez arracher.', 147),
(5, 'guest5@example.com', 'Très même élever propos trop.', 'Parce Que fonction parcourir dresser continuer prévoir toit fixer.', '2025-09-15', 'J6YV6PTB60CNNNNJ2JQ6', 'Siècle fond gauche il passage abri fermer un chasser aussitôt.', 3),
(6, 'guest6@example.com', 'Docteur quatre réunir quel petit.', 'Sourire prendre abri quelqu\'\'un.', '2025-09-16', 'G1MJLPUQIUXJZO2LE6JP', 'Gouvernement déposer violence visible.', 172),
(7, 'guest7@example.com', 'Toucher parler blond ailleurs bataille entraîner effacer.', 'Rocher accompagner trait certain.', '2025-09-17', '0U9OAW7WX74UQEJT6310', 'Faveur tenir sol rayon suivant jeter cinq couvrir remplir verre.', 85),
(8, 'guest8@example.com', 'Liberté d\'\'abord relation rompre condition.', 'Cent planche social résoudre.', '2025-09-18', 'VHPJQHVOJ5L6EGLQWDAH', 'Perte considérer matin tourner danger.', 176),
(9, 'guest9@example.com', 'Derrière esprit maison femme parti lien.', 'Mine soulever tranquille pousser surtout chasse.', '2025-09-19', 'VTOQRMDZ91S9RUMR3DWB', 'Cause éclairer face cacher signe classe connaître rayon épais besoin tête.', 194),
(10, 'guest10@example.com', 'Moins mener argent million étroit tempête.', 'Allumer étaler rideau envoyer après.', '2025-09-20', '839JGZZW0DFSFG7158XF', 'Précis nature profondément dame coeur jamais victime.', 65),
(11, 'visiteur@example.com', 'Demande d\'information', 'Bonjour, je souhaite obtenir des précisions sur les réservations.', '2025-10-29', 'e0e5de24af7623b2f563', 'nous n\'avons  pas une  liste de tarifs', 1),
(15, 'jeanpaul@lol.com', 'aider pour inscription de mineur', ' Je veux inscrire mon fils à l\'association', '2025-11-15', '5bca5b2145ee08ed2a96', NULL, NULL),
(16, 'janor@gmail.com', 'essai de  association', 'Je voudrais essayer pour une réservation comme inviter', '2025-11-15', '7cbc7abc6238231947b1', NULL, NULL),
(17, 'janor@gmail.com', 'essai de  association', 'aaaaaaaasaa', '2025-11-15', 'ccbd280f1be501c2a276', 'je ne  comprend pas votre message', 3),
(18, 'janort@gmail.com', 'aide   pour inscription', 'incription ', '2025-11-15', '6fbc9c66ae7adcbd8a77', 'Select * From t_compte_cpt', 3),
(19, 'tester.email@gmail.com', 'problem de connection', 'Mon mot de passe ne fonctionne pas', '2025-11-16', '79e8ad5486bcad48624b', NULL, NULL),
(20, 'aleksi.loddo@gmail.com', 'teste', 'teste', '2025-11-18', '986f312116c94e82bcf2', 'je repond au test', 3),
(21, 'vm@gmail.com', 'l\'adhession', 'quelle est le prix?', '2025-11-19', 'adbd713e03479c87a0d4', 'le prix et deux 90€ l\'année', 3),
(22, 'adonis@gmail.com', 'teste', 'teste', '2025-11-26', '1343253bf87081f7a939', NULL, NULL),
(23, 'adonis@gmail.com', 'Teste*\'A', 'message*test!/è', '2025-12-01', '96c7a959fe97b02b12aa', '\'éé\'\"(\'-è_ityhrgsegqf14+98ga', 3),
(24, 'adonis@gmail.com', 'g', 'g', '2025-12-01', 'ee5749212b379a384ae3', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `t_participer_par`
--

CREATE TABLE `t_participer_par` (
  `reu_id` int(11) NOT NULL,
  `com_id` int(11) NOT NULL,
  `par_dateinscription` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `t_participer_par`
--

INSERT INTO `t_participer_par` (`reu_id`, `com_id`, `par_dateinscription`) VALUES
(1, 1, '2025-09-20'),
(1, 7, '2025-10-01'),
(2, 2, '2025-09-21'),
(3, 3, '2025-09-22'),
(4, 3, '2025-10-05'),
(4, 6, '2025-10-05'),
(4, 7, '2025-10-05'),
(4, 9, '2025-10-05');

--
-- Triggers `t_participer_par`
--
DELIMITER $$
CREATE TRIGGER `participant_deinscrit` AFTER DELETE ON `t_participer_par` FOR EACH ROW BEGIN
    
    
    CALL reunion_document_cree_modif(OLD.reu_id);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `participant_inscrit` AFTER INSERT ON `t_participer_par` FOR EACH ROW BEGIN
    
    
    CALL reunion_document_cree_modif(NEW.reu_id);

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `t_profil_pro`
--

CREATE TABLE `t_profil_pro` (
  `com_id` int(11) NOT NULL,
  `pro_role` char(1) NOT NULL,
  `pro_nom` varchar(60) NOT NULL,
  `pro_prenom` varchar(60) NOT NULL,
  `pro_datedenaissance` date NOT NULL,
  `pro_mail` varchar(200) NOT NULL,
  `pro_adress` varchar(120) NOT NULL,
  `pro_telmob` varchar(12) DEFAULT NULL,
  `pro_telfix` varchar(12) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `t_profil_pro`
--

INSERT INTO `t_profil_pro` (`com_id`, `pro_role`, `pro_nom`, `pro_prenom`, `pro_datedenaissance`, `pro_mail`, `pro_adress`, `pro_telmob`, `pro_telfix`) VALUES
(1, 'A', 'Emile', 'Pascal', '1975-01-15', 'pascal.emile@example.com', '1 rue Admin 75000 Paris', '0600000001', NULL),
(2, 'A', 'Juliette', 'Girard', '1978-03-22', 'juliette.girard@example.com', '2 rue Admin 75000 Paris', '0600000002', NULL),
(3, 'A', 'Patrick', 'Riviere', '1980-07-12', 'patrick.riviere@example.com', '3 rue Admin 75000 Paris', '0600000003', ''),
(4, 'A', 'Eleonore', 'Breton', '1982-09-05', 'eleonore.breton@example.com', '4 rue Admin 75000 Paris', '0600000004', NULL),
(5, 'A', 'Dominique', 'Renard', '1979-12-20', 'dominique.renard@example.com', '5 rue Admin 75000 Paris', '0600000005', NULL),
(6, 'M', 'Gaudin', 'Alice', '1983-02-11', 'alice.gaudin1@example.com', '708, rue de Leclerc 33279 Poirier', '0600000006', NULL),
(7, 'M', 'Gros', 'Alain', '1966-03-07', 'alain.gros2@example.com', '42, chemin de Poirier 55263 Hamel-sur-Lebreton', '0600000007', NULL),
(8, 'M', 'Gonzalez', 'Denis', '1994-06-15', 'denis.gonzalez3@example.com', '95, rue Faivre 85587 Bertin', '0600000008', NULL),
(9, 'M', 'Mercier', 'Henri', '1980-09-05', 'henri.mercier4@example.com', '79, chemin Georges Merle 92415 Rousset', '0600000009', NULL),
(10, 'M', 'Caron', 'Clémence', '2004-01-30', 'clemence.caron5@example.com', '311, chemin Zoé Bonneau 09199 Boulay', '0600000010', NULL),
(11, 'M', 'Léger', 'Maurice', '2005-10-30', 'maurice.leger6@example.com', '13, avenue de Pascal 48453 Albert', '0600000011', ''),
(12, 'M', 'Toussaint', 'Lucie', '2004-05-29', 'lucie.toussaint7@example.com', '9, boulevard de Turpin 16656 Saint Camille', '0600000012', NULL),
(13, 'M', 'Valette', 'Sébastien', '1965-10-03', 'sebastien.valette8@example.com', '97, rue Philippe Noël 58028 Le GallBourg', '0600000013', NULL),
(14, 'M', 'Barre', 'Pierre', '1977-05-29', 'pierre.barre9@example.com', '60, chemin Benjamin Dubois 44602 Morvan', '0600000014', NULL),
(15, 'M', 'Rémy', 'Joséphine', '1983-11-17', 'josephine.remy10@example.com', '49, rue Margaux Didier 72339 Sainte Nathalie-la-Forêt', '0600000015', NULL),
(16, 'M', 'Caron', 'Georges', '2006-05-24', 'georges.caron11@example.com', '70, boulevard de Lucas 33081 Camus', '0600000016', NULL),
(17, 'M', 'Klein', 'Anaïs', '1960-02-29', 'anais.klein12@example.com', '40, rue René Hervé 21202 Brunet', '0600000017', NULL),
(18, 'M', 'Vallée', 'Patricia', '2001-10-24', 'patricia.vallee13@example.com', 'rue de Martins 11535 Bouvier', '0600000018', NULL),
(19, 'M', 'Verdier', 'Michelle', '1987-12-14', 'michelle.verdier14@example.com', '95, boulevard Vasseur 83452 Bigot-sur-Tessier', '0600000019', NULL),
(20, 'M', 'Gay', 'Arthur', '2002-11-13', 'arthur.gay15@example.com', '41, chemin Hernandez 98378 TurpinBourg', '0600000020', NULL),
(21, 'M', 'Delaunay', 'Renée', '1981-08-15', 'renee.delaunay16@example.com', '6, rue Techer 19004 Sainte Marianne-la-Forêt', '0600000021', NULL),
(22, 'M', 'Prévost', 'Grégoire', '1960-01-23', 'gregoire.prevost17@example.com', '4, rue de Maillot 88558 Leclercq', '0600000022', NULL),
(23, 'M', 'Maurice', 'Nicole', '1967-11-29', 'nicole.maurice18@example.com', '19, boulevard de Ruiz 23528 Arnaudnec', '0600000023', NULL),
(24, 'M', 'Vallée', 'Georges', '1978-12-30', 'georges.vallee19@example.com', '19, rue Michèle Dumont 21167 Perret-sur-Ollivier', '0600000024', NULL),
(25, 'M', 'Charrier', 'Gilbert', '1980-11-17', 'gilbert.charrier20@example.com', '14, boulevard de Evrard 54377 Guilbert', '0600000025', NULL),
(26, 'M', 'Torres', 'Nicolas', '1970-08-22', 'nicolas.torres21@example.com', '52, chemin Boucher 34620 Perrin', '0600000026', NULL),
(27, 'M', 'Royer', 'Sylvie', '1980-04-22', 'sylvie.royer22@example.com', '81, boulevard de Barbier 56126 Paul', '0600000027', NULL),
(28, 'M', 'Pruvost', 'Hélène', '1967-06-20', 'helene.pruvost23@example.com', '395, avenue Maurice Lévêque 86169 Pottier', '0600000028', NULL),
(29, 'M', 'Rousseau', 'Anaïs', '2007-09-07', 'anais.rousseau24@example.com', '86, boulevard Marc Bertrand 38007 Fournier-sur-Masson', '0600000029', NULL),
(30, 'M', 'Rolland', 'Daniel', '1996-03-07', 'daniel.rolland25@example.com', '17, avenue Michelle Parent 63264 Bouchet', '0600000030', NULL),
(31, 'M', 'Devaux', 'Cécile', '1965-12-12', 'cecile.devaux26@example.com', '835, chemin Hortense Barbe 88364 Philippenec', '0600000031', NULL),
(32, 'M', 'Georges', 'Maggie', '1996-04-07', 'maggie.georges27@example.com', '80, boulevard Weber 02088 Saint Tristanboeuf', '0600000032', NULL),
(33, 'M', 'Lambert', 'Joseph', '1999-07-27', 'joseph.lambert28@example.com', '538, avenue Sabine Renault 81846 Parent-sur-Lombard', '0600000033', NULL),
(34, 'M', 'Le Goff', 'Jeanne', '1980-03-02', 'jeanne.le.goff29@example.com', '56, avenue Normand 79151 Lévêque-les-Bains', '0600000034', NULL),
(35, 'M', 'Salmon', 'Thérèse', '1968-09-01', 'therese.salmon30@example.com', '4, avenue de Seguin 81281 Saint Jeannine', '0600000035', NULL),
(36, 'M', 'Prévost', 'Alain', '1967-12-24', 'alain.prevost31@example.com', '41, avenue Jules Perret 07387 Maillot', '0600000036', NULL),
(37, 'M', 'Laurent', 'Marcel', '1984-05-04', 'marcel.laurent32@example.com', 'rue Gay 52955 Navarro-la-Forêt', '0600000037', NULL),
(38, 'M', 'Guichard', 'Gérard', '1977-03-13', 'gerard.guichard33@example.com', '74, boulevard Lefèvre 28765 Texier', '0600000038', NULL),
(39, 'M', 'Bruneau', 'Aurélie', '1971-03-06', 'aurelie.bruneau34@example.com', 'avenue de Maury 78891 Denis', '0600000039', NULL),
(40, 'M', 'Léger', 'Jules', '1980-02-26', 'jules.leger35@example.com', '31, rue de Dufour 71767 Saint NicolasBourg', '0600000040', NULL),
(41, 'M', 'Turpin', 'Inès', '2006-08-22', 'ines.turpin36@example.com', '6, chemin Margot Martin 78070 Clément-les-Bains', '0600000041', NULL),
(42, 'M', 'Dubois', 'Louis', '1992-09-18', 'louis.dubois37@example.com', '892, rue Hoarau 43626 Sainte Christophe', '0600000042', NULL),
(43, 'M', 'Maréchal', 'Bertrand', '1979-10-01', 'bertrand.marechal38@example.com', '7, chemin Laine 33963 Marionboeuf', '0600000043', NULL),
(44, 'M', 'Brun', 'Margaud', '1997-09-03', 'margaud.brun39@example.com', '140, chemin Dufour 77752 Schmitt', '0600000044', NULL),
(45, 'M', 'Techer', 'Clémence', '2004-05-17', 'clemence.techer40@example.com', '5, chemin Henry 83138 Morel', '0600000045', NULL),
(46, 'M', 'Maurice', 'Hugues', '2002-06-14', 'hugues.maurice41@example.com', '67, boulevard Petitjean 74312 Saint Marcel', '0600000046', NULL),
(47, 'M', 'Mace', 'Josette', '1982-01-02', 'josette.mace42@example.com', '10, rue de Fouquet 03481 Thomas', '0600000047', NULL),
(48, 'M', 'Raynaud', 'Léon', '1971-06-07', 'leon.raynaud43@example.com', '38, rue de Lamy 37523 Sainte Thérèsedan', '0600000048', NULL),
(49, 'M', 'Lagarde', 'Marcel', '2004-11-25', 'marcel.lagarde44@example.com', '61, avenue de Leroy 95136 Guilbertboeuf', '0600000049', NULL),
(50, 'M', 'Dumont', 'Honoré', '1990-01-07', 'honore.dumont45@example.com', '37, chemin Théophile Diallo 34221 Michaud', '0600000050', NULL),
(51, 'M', 'Colas', 'Philippe', '1967-04-12', 'philippe.colas46@example.com', '7, boulevard Bonnin 79425 Richard', '0600000051', NULL),
(52, 'M', 'Boulanger', 'Gabriel', '2004-06-20', 'gabriel.boulanger47@example.com', '4, chemin Duval 92070 Martins', '0600000052', NULL),
(53, 'M', 'Breton', 'Laurence', '1962-06-17', 'laurence.breton48@example.com', '1, boulevard Véronique Chauvin 53909 Humbert', '0600000053', NULL),
(54, 'M', 'Imbert', 'Marine', '1999-06-29', 'marine.imbert49@example.com', 'rue Tessier 13078 Julien', '0600000054', NULL),
(55, 'M', 'Marin', 'Pauline', '1990-09-08', 'pauline.marin50@example.com', '59, avenue de Thibault 13248 Paris', '0600000055', NULL),
(56, 'M', 'Barbe', 'Suzanne', '2003-01-26', 'suzanne.barbe51@example.com', 'rue Marion 40493 Jacquot', '0600000056', NULL),
(57, 'M', 'Ferrand', 'Colette', '2005-12-29', 'colette.ferrand52@example.com', '1, rue Susan Cordier 58369 Maillet-la-Forêt', '0600000057', NULL),
(58, 'M', 'Chauvet', 'Emmanuel', '2007-03-06', 'emmanuel.chauvet53@example.com', '688, boulevard David Ledoux 79913 Pruvost', '0600000058', NULL),
(59, 'M', 'Maillot', 'Anne', '1969-11-07', 'anne.maillot54@example.com', '1, rue Sébastien Allard 94968 Lelièvre-sur-Becker', '0600000059', NULL),
(60, 'M', 'Barre', 'Élisabeth', '1980-08-17', 'elisabeth.barre55@example.com', '80, rue de Guillet 56088 WeissVille', '0600000060', NULL),
(61, 'M', 'Marie', 'Robert', '1984-04-28', 'robert.marie56@example.com', '41, boulevard Millet 69455 Germain', '0600000061', NULL),
(62, 'M', 'Allard', 'Rémy', '1989-12-05', 'remy.allard57@example.com', '143, rue Martine Seguin 14675 Sainte Thibaut', '0600000062', NULL),
(63, 'M', 'Maury', 'Denis', '2001-02-16', 'denis.maury58@example.com', '679, rue de Blondel 58576 Besnard-sur-Paul', '0600000063', NULL),
(64, 'M', 'Techer', 'Nicolas', '2005-10-22', 'nicolas.techer59@example.com', 'boulevard de Perrier 16091 Mendèsnec', '0600000064', NULL),
(65, 'M', 'Menard', 'Lorraine', '1961-11-18', 'lorraine.menard60@example.com', '1, rue Rivière 39234 Lecomte', '0600000065', NULL),
(66, 'M', 'Blot', 'Timothée', '1990-06-10', 'timothee.blot61@example.com', '75, rue de Allain 96915 Hoarau-la-Forêt', '0600000066', NULL),
(67, 'M', 'Maury', 'Lucas', '2000-05-28', 'lucas.maury62@example.com', '26, chemin de Paris 71671 Renault', '0600000067', NULL),
(68, 'M', 'Daniel', 'Marc', '1970-08-14', 'marc.daniel63@example.com', '25, chemin Dubois 13898 Maillot-sur-Joly', '0600000068', NULL),
(69, 'M', 'David', 'Thomas', '2004-06-12', 'thomas.david64@example.com', '875, avenue de Le Roux 66601 Renardboeuf', '0600000069', NULL),
(70, 'M', 'Fleury', 'Joseph', '1998-06-12', 'joseph.fleury65@example.com', '4, boulevard Besson 61383 Lesage', '0600000070', NULL),
(71, 'M', 'Ramos', 'Alain', '1995-01-03', 'alain.ramos66@example.com', '88, chemin Émilie Adam 30366 Delormenec', '0600000071', NULL),
(72, 'M', 'Bernier', 'Amélie', '1965-09-17', 'amelie.bernier67@example.com', '2, rue de Briand 47242 Martineau-la-Forêt', '0600000072', NULL),
(73, 'M', 'Delattre', 'Catherine', '1991-10-28', 'catherine.delattre68@example.com', 'rue Brigitte Gérard 28937 Schneider-sur-Texier', '0600000073', NULL),
(74, 'M', 'Nguyen', 'Valérie', '1967-03-14', 'valerie.nguyen69@example.com', '26, avenue de Renaud 05395 Lebrun-la-Forêt', '0600000074', NULL),
(75, 'M', 'Aubry', 'Bernadette', '1972-07-07', 'bernadette.aubry70@example.com', '77, avenue Ribeiro 07909 Pascal', '0600000075', NULL),
(76, 'M', 'Huet', 'Guy', '1979-11-30', 'guy.huet71@example.com', '822, chemin de Pierre 62320 Royer-la-Forêt', '0600000076', NULL),
(77, 'M', 'Coulon', 'Victoire', '1991-04-10', 'victoire.coulon72@example.com', '88, avenue Vaillant 14337 Saint Françoisenec', '0600000077', NULL),
(78, 'M', 'Pelletier', 'Édouard', '1978-12-22', 'edouard.pelletier73@example.com', '60, boulevard Jacques Hardy 37908 Lemaire-sur-Mer', '0600000078', NULL),
(79, 'M', 'Vallée', 'Frédérique', '1975-03-06', 'frederique.vallee74@example.com', '21, avenue Briand 03667 Mallet-la-Forêt', '0600000079', NULL),
(80, 'M', 'Deschamps', 'Aimée', '2000-08-15', 'aimee.deschamps75@example.com', '8, boulevard de Carpentier 79374 Fontaine-sur-Mer', '0600000080', NULL),
(81, 'M', 'Chauvet', 'Léon', '1961-04-05', 'leon.chauvet76@example.com', '34, boulevard de Denis 87790 Girard', '0600000081', NULL),
(82, 'M', 'Verdier', 'Capucine', '1982-02-13', 'capucine.verdier77@example.com', '77, rue Lecoq 32070 Martinsdan', '0600000082', NULL),
(83, 'M', 'Briand', 'Mathilde', '1967-08-06', 'mathilde.briand78@example.com', '7, avenue Marguerite Lecoq 59307 Blanchard', '0600000083', NULL),
(84, 'M', 'Blin', 'Hélène', '1988-08-11', 'helene.blin79@example.com', '71, rue de Le Gall 83735 Riou', '0600000084', NULL),
(85, 'M', 'Martins', 'Bernard', '1974-02-21', 'bernard.martins80@example.com', '57, avenue Guyot 44465 Gonzalez', '0600000085', NULL),
(86, 'M', 'Guyon', 'Théodore', '1965-03-16', 'theodore.guyon81@example.com', '96, rue de Hervé 17015 Chauveau-sur-Allain', '0600000086', NULL),
(87, 'M', 'Riou', 'Clémence', '1989-10-18', 'clemence.riou82@example.com', '81, rue Gilbert 93332 Masson', '0600000087', NULL),
(88, 'M', 'Benard', 'Honoré', '1970-02-14', 'honore.benard83@example.com', '98, rue de Blin 50030 Dijoux', '0600000088', NULL),
(89, 'M', 'Blanchard', 'Robert', '1986-04-23', 'robert.blanchard84@example.com', '98, rue Antoine Carpentier 97467 BourdonVille', '0600000089', NULL),
(90, 'M', 'Potier', 'Jacques', '1975-08-16', 'jacques.potier85@example.com', '54, avenue Aurélie Morel 43398 Lemoine', '0600000090', NULL),
(91, 'M', 'Legrand', 'Adrien', '1996-11-25', 'adrien.legrand86@example.com', '898, boulevard de Dupuis 46249 Sainte Capucinedan', '0600000091', NULL),
(92, 'M', 'Dos Santos', 'Denis', '1969-04-04', 'denis.dos.santos87@example.com', '18, avenue de Marchand 59435 Jacob', '0600000092', NULL),
(93, 'M', 'Poulain', 'Geneviève', '1991-04-12', 'genevieve.poulain88@example.com', '38, rue Paris 54692 Da Silva-sur-Mercier', '0600000093', NULL),
(94, 'M', 'Girard', 'Françoise', '1972-05-09', 'francoise.girard89@example.com', '61, avenue Pierre 88431 Chauveau-sur-Dufour', '0600000094', NULL),
(95, 'M', 'Grégoire', 'Bertrand', '1963-02-11', 'bertrand.gregoire90@example.com', '22, boulevard Louis Charrier 93327 Bertrandnec', '0600000095', NULL),
(96, 'M', 'Jacquet', 'Bernadette', '1982-01-11', 'bernadette.jacquet91@example.com', '5, boulevard Agathe Jacquet 38666 Rodriguez-les-Bains', '0600000096', NULL),
(97, 'M', 'Berger', 'Céline', '1994-02-27', 'celine.berger92@example.com', 'avenue Gay 60376 Chevalierdan', '0600000097', NULL),
(98, 'M', 'Lemaître', 'Paulette', '1964-01-30', 'paulette.lemaitre93@example.com', 'avenue Julie Aubert 66485 Moreno', '0600000098', NULL),
(99, 'M', 'Hardy', 'Alix', '1983-06-10', 'alix.hardy94@example.com', '37, rue Lelièvre 98739 Fernandezboeuf', '0600000099', NULL),
(100, 'M', 'Gonzalez', 'Benjamin', '1970-08-24', 'benjamin.gonzalez95@example.com', '63, chemin Pineau 06691 Morelnec', '0600000100', NULL),
(101, 'M', 'Jacques', 'Nicolas', '1965-05-08', 'nicolas.jacques96@example.com', '14, chemin Denis 06700 Brun-les-Bains', '0600000101', NULL),
(102, 'M', 'Jean', 'Marie', '1973-07-12', 'marie.jean97@example.com', '8, chemin de Marty 11416 David', '0600000102', NULL),
(103, 'M', 'Boulanger', 'Patricia', '1993-07-09', 'patricia.boulanger98@example.com', '66, chemin Susanne Camus 90466 Sainte Lucy', '0600000103', NULL),
(104, 'M', 'Labbé', 'Élodie', '1975-11-11', 'elodie.labbe99@example.com', '4, chemin Martins 92336 Saint Roger', '0600000104', NULL),
(105, 'M', 'Lecomte', 'Yves', '1999-03-13', 'yves.lecomte100@example.com', '6, boulevard Alexandrie Muller 84267 Martel', '0600000105', NULL),
(106, 'M', 'Olivier', 'Claudine', '1965-08-09', 'claudine.olivier101@example.com', '47, avenue de Klein 20842 Benoit-sur-Rossi', '0600000106', NULL),
(107, 'M', 'Perret', 'Bertrand', '1980-12-14', 'bertrand.perret102@example.com', 'boulevard Laurence Lejeune 34862 Chauvet', '0600000107', NULL),
(108, 'M', 'Imbert', 'Denis', '1987-08-19', 'denis.imbert103@example.com', '29, chemin Merle 79193 Sainte RenéeVille', '0600000108', NULL),
(109, 'M', 'Lemoine', 'Alain', '2006-11-17', 'alain.lemoine104@example.com', '327, rue de Dumas 95044 Sainte Raymonddan', '0600000109', NULL),
(110, 'M', 'Cordier', 'Valentine', '1974-02-03', 'valentine.cordier105@example.com', '67, avenue Frédérique Besnard 08945 Martinsdan', '0600000110', NULL),
(111, 'M', 'Barre', 'Nicolas', '1992-07-13', 'nicolas.barre106@example.com', '8, rue de Voisin 37933 Saint Marianne', '0600000111', NULL),
(112, 'M', 'Garcia', 'Laurence', '1991-04-21', 'laurence.garcia107@example.com', 'avenue Dupont 23700 GillesVille', '0600000112', NULL),
(113, 'M', 'Maillot', 'Hélène', '1988-11-03', 'helene.maillot108@example.com', 'avenue de Raynaud 09068 Sanchezboeuf', '0600000113', NULL),
(114, 'M', 'Dufour', 'Margot', '1975-06-07', 'margot.dufour109@example.com', '10, avenue Thibaut Vincent 69457 Sainte Grégoire', '0600000114', NULL),
(115, 'M', 'Roy', 'Juliette', '1981-10-12', 'juliette.roy110@example.com', '45, rue Georges Sauvage 92602 PruvostVille', '0600000115', NULL),
(116, 'M', 'Huet', 'Lucie', '1999-09-02', 'lucie.huet111@example.com', 'avenue Hugues Bouvet 72094 Saint Laure-la-Forêt', '0600000116', NULL),
(117, 'M', 'Dumas', 'Noël', '1974-08-15', 'noel.dumas112@example.com', 'rue de Bègue 27607 Sainte Daniellenec', '0600000117', NULL),
(118, 'M', 'Ferrand', 'Élodie', '1994-03-14', 'elodie.ferrand113@example.com', '18, chemin Grégoire Martineau 74477 Bonneau', '0600000118', NULL),
(119, 'M', 'Guillaume', 'Marcelle', '1996-12-03', 'marcelle.guillaume114@example.com', '117, chemin de Mathieu 54070 Fabre', '0600000119', NULL),
(120, 'M', 'David', 'Maurice', '1987-07-19', 'maurice.david115@example.com', '111, boulevard Guyon 89412 Dufour', '0600000120', NULL),
(121, 'M', 'Launay', 'Alice', '1985-04-13', 'alice.launay116@example.com', '838, rue Thibaut Leroux 68275 Charpentier', '0600000121', NULL),
(122, 'M', 'Payet', 'Georges', '1968-10-15', 'georges.payet117@example.com', '53, boulevard de Jacquet 57421 Lecoq', '0600000122', NULL),
(123, 'M', 'Mallet', 'Victoire', '1986-11-20', 'victoire.mallet118@example.com', '9, rue de Chevalier 00793 Sainte SuzanneVille', '0600000123', NULL),
(124, 'M', 'Duval', 'Théophile', '1984-02-15', 'theophile.duval119@example.com', '77, rue Michelle Chartier 31455 Legros', '0600000124', NULL),
(125, 'M', 'Blanchet', 'Thérèse', '1970-03-08', 'therese.blanchet120@example.com', '9, avenue Boutin 79525 Auger', '0600000125', NULL),
(126, 'M', 'Gay', 'Joséphine', '1970-11-20', 'josephine.gay121@example.com', 'avenue Christiane Le Roux 56544 Georges', '0600000126', NULL),
(127, 'M', 'Renard', 'Laure', '1979-10-06', 'laure.renard122@example.com', 'rue de Fabre 21200 Gaudin', '0600000127', NULL),
(128, 'M', 'Delmas', 'Hugues', '2007-03-28', 'hugues.delmas123@example.com', '77, chemin de Rossi 20171 Saint Yves-la-Forêt', '0600000128', NULL),
(129, 'M', 'Brunet', 'Émile', '1965-08-10', 'emile.brunet124@example.com', '77, chemin Sylvie Deschamps 73804 ChevallierVille', '0600000129', NULL),
(130, 'M', 'Godard', 'Guillaume', '1977-08-20', 'guillaume.godard125@example.com', '591, avenue Hernandez 91031 Mace', '0600000130', NULL),
(131, 'M', 'Bertin', 'Françoise', '1991-10-26', 'francoise.bertin126@example.com', 'rue de Da Costa 58906 Saint Guy', '0600000131', NULL),
(132, 'M', 'Lefèvre', 'Virginie', '1971-12-05', 'virginie.lefevre127@example.com', '5, boulevard de Marty 67700 Josephboeuf', '0600000132', NULL),
(133, 'M', 'Collet', 'Bernard', '1970-07-21', 'bernard.collet128@example.com', 'avenue Pénélope Dias 21430 Sainte Alice', '0600000133', NULL),
(134, 'M', 'Fernandes', 'Guy', '2002-05-26', 'guy.fernandes129@example.com', '32, rue de Caron 12292 Mathieu', '0600000134', NULL),
(135, 'M', 'Chrétien', 'Julien', '1963-09-18', 'julien.chretien130@example.com', '500, boulevard Christine Collin 24722 Sainte Christiane', '0600000135', NULL),
(136, 'M', 'Pons', 'Odette', '1962-01-08', 'odette.pons131@example.com', '57, boulevard de Clerc 33522 Saint Jacquelinenec', '0600000136', NULL),
(137, 'M', 'Perret', 'Marc', '1998-01-04', 'marc.perret132@example.com', 'chemin de Navarro 45932 Aubertboeuf', '0600000137', NULL),
(138, 'M', 'Jacob', 'Honoré', '1966-12-30', 'honore.jacob133@example.com', '63, avenue Augustin Samson 49455 Bernard', '0600000138', NULL),
(139, 'M', 'Noël', 'Susan', '1975-09-18', 'susan.noel134@example.com', '53, chemin Munoz 44947 Sainte Adélaïde-sur-Mer', '0600000139', NULL),
(140, 'M', 'Dupuy', 'Thibault', '1994-02-14', 'thibault.dupuy135@example.com', '36, boulevard Couturier 76322 Picard-sur-Renard', '0600000140', NULL),
(141, 'M', 'Da Costa', 'Virginie', '1966-07-24', 'virginie.da.costa136@example.com', '53, avenue de Pons 57584 Dupuy', '0600000141', NULL),
(142, 'M', 'David', 'Victor', '1969-01-12', 'victor.david137@example.com', '11, boulevard Patrick Schneider 05298 Roger', '0600000142', NULL),
(143, 'M', 'Ferreira', 'Nathalie', '1998-05-27', 'nathalie.ferreira138@example.com', '513, boulevard de Blondel 56195 Pelletier', '0600000143', NULL),
(144, 'M', 'Guillet', 'Denise', '1992-05-12', 'denise.guillet139@example.com', '53, rue Delmas 76874 Becker-les-Bains', '0600000144', NULL),
(145, 'M', 'Poirier', 'Christine', '1987-08-30', 'christine.poirier140@example.com', 'rue Lemonnier 03744 Gosselin', '0600000145', NULL),
(146, 'M', 'Lemoine', 'Martine', '1964-05-22', 'martine.lemoine141@example.com', '18, rue Mallet 20019 Saint Laurent', '0600000146', NULL),
(147, 'M', 'Richard', 'Patrick', '1996-03-21', 'patrick.richard142@example.com', '419, rue Evrard 35668 Vasseur', '0600000147', NULL),
(148, 'M', 'Martineau', 'Bernard', '1984-06-26', 'bernard.martineau143@example.com', '156, avenue de Lecomte 18581 Ledoux', '0600000148', NULL),
(149, 'M', 'Delannoy', 'Mathilde', '1991-10-11', 'mathilde.delannoy144@example.com', '39, rue Eugène Faivre 97686 Saint Théophiledan', '0600000149', NULL),
(150, 'M', 'Maury', 'Dominique', '1989-08-09', 'dominique.maury145@example.com', '41, rue Joseph Bigot 90467 Dupuy', '0600000150', NULL),
(151, 'M', 'Bailly', 'Zoé', '1998-03-29', 'zoe.bailly146@example.com', 'avenue de Peron 79279 Saint Louis', '0600000151', NULL),
(152, 'M', 'Lemonnier', 'Aurore', '1968-10-07', 'aurore.lemonnier147@example.com', '35, chemin Daniel 46973 Saint Valérie', '0600000152', NULL),
(153, 'M', 'Robin', 'François', '1993-04-09', 'francois.robin148@example.com', '5, avenue Dorothée Cordier 75015 ColletVille', '0600000153', NULL),
(154, 'M', 'Perez', 'Céline', '1991-06-24', 'celine.perez149@example.com', '262, rue de Rousseau 08396 Masse-sur-Nicolas', '0600000154', NULL),
(155, 'M', 'Maillot', 'Marguerite', '1972-01-22', 'marguerite.maillot150@example.com', 'rue Emmanuel Dupuy 28319 Mercier', '0600000155', NULL),
(156, 'M', 'Vidal', 'Éric', '1996-05-05', 'eric.vidal151@example.com', '45, rue Couturier 48571 GimenezBourg', '0600000156', NULL),
(157, 'M', 'Mercier', 'Louise', '1996-11-12', 'louise.mercier152@example.com', '6, avenue Léger 67479 Renard', '0600000157', NULL),
(158, 'M', 'Peltier', 'Isabelle', '1976-03-03', 'isabelle.peltier153@example.com', '81, avenue de Aubry 71892 Pereira-sur-Mer', '0600000158', NULL),
(159, 'M', 'Blanchet', 'Josette', '1998-06-26', 'josette.blanchet154@example.com', '55, boulevard François 77043 Guibert-sur-Richard', '0600000159', NULL),
(160, 'M', 'Lemoine', 'Hélène', '1981-03-03', 'helene.lemoine155@example.com', '72, rue Durand 24903 Sainte Jules', '0600000160', NULL),
(161, 'M', 'Collin', 'Amélie', '1995-12-08', 'amelie.collin156@example.com', '677, avenue de Bouchet 77411 Bernierboeuf', '0600000161', NULL),
(162, 'M', 'Mallet', 'Théodore', '2000-08-09', 'theodore.mallet157@example.com', '89, chemin de Guillou 50721 Lenoir', '0600000162', NULL),
(163, 'M', 'Pineau', 'Arthur', '1983-03-06', 'arthur.pineau158@example.com', '86, avenue de Besnard 92100 Pelletier', '0600000163', NULL),
(164, 'M', 'Louis', 'Aurélie', '1966-10-14', 'aurelie.louis159@example.com', '182, chemin Brun 45171 PintoBourg', '0600000164', NULL),
(165, 'M', 'Thibault', 'Auguste', '2000-11-29', 'auguste.thibault160@example.com', '544, rue Grégoire 50139 Lemonnierdan', '0600000165', NULL),
(166, 'M', 'Teixeira', 'Paulette', '2000-11-10', 'paulette.teixeira161@example.com', '10, avenue de Techer 68735 Saint Thibaut-la-Forêt', '0600000166', NULL),
(167, 'M', 'Roger', 'Valentine', '1967-11-26', 'valentine.roger162@example.com', '73, avenue Nathalie Martinez 33436 Morin-sur-Marques', '0600000167', NULL),
(168, 'M', 'Ferrand', 'Capucine', '2005-04-12', 'capucine.ferrand163@example.com', '98, rue Cordier 93219 Martel', '0600000168', NULL),
(169, 'M', 'Fernandez', 'Laurence', '1987-12-18', 'laurence.fernandez164@example.com', '47, avenue Claire Delattre 79213 Sainte Hélène-la-Forêt', '0600000169', NULL),
(170, 'M', 'Mace', 'Julie', '1965-04-25', 'julie.mace165@example.com', '588, chemin Jacquet 67131 Hardynec', '0600000170', NULL),
(171, 'M', 'Duhamel', 'René', '1969-11-08', 'rene.duhamel166@example.com', '30, avenue Étienne Petitjean 43801 Leroy-sur-Mer', '0600000171', NULL),
(172, 'M', 'Costa', 'Michel', '1990-01-01', 'michel.costa167@example.com', '7, boulevard Anaïs Pons 72452 Marion', '0600000172', NULL),
(173, 'M', 'Gros', 'Marguerite', '1981-05-08', 'marguerite.gros168@example.com', 'boulevard Jérôme Pineau 97140 PotierBourg', '0600000173', NULL),
(174, 'M', 'Auger', 'Gérard', '1973-04-13', 'gerard.auger169@example.com', '94, avenue Jeannine Lejeune 57669 Sainte Élodie', '0600000174', NULL),
(175, 'M', 'Guilbert', 'Guillaume', '1966-05-04', 'guillaume.guilbert170@example.com', '23, rue de Bègue 92188 Sainte Susan', '0600000175', NULL),
(176, 'M', 'Maillet', 'Aurélie', '1968-05-11', 'aurelie.maillet171@example.com', '4, rue Charlotte Gomez 52263 Pruvost', '0600000176', NULL),
(177, 'M', 'Blin', 'Claudine', '1983-08-15', 'claudine.blin172@example.com', 'rue Roux 53493 Bouchet-sur-Mer', '0600000177', NULL),
(178, 'M', 'Lopez', 'Denis', '1963-03-17', 'denis.lopez173@example.com', '556, rue Aurore Labbé 35565 Saint Danielle', '0600000178', NULL),
(179, 'M', 'Briand', 'Anne', '2001-06-29', 'anne.briand174@example.com', 'boulevard de Benard 30452 Thomas', '0600000179', NULL),
(180, 'M', 'David', 'Julien', '1997-07-18', 'julien.david175@example.com', '7, chemin Zacharie Prévost 80420 Collin', '0600000180', NULL),
(181, 'M', 'Martinez', 'Aurélie', '1992-07-26', 'aurelie.martinez176@example.com', '8, avenue de Grenier 83270 Saint François', '0600000181', NULL),
(182, 'M', 'Maury', 'Joséphine', '1972-05-16', 'josephine.maury177@example.com', 'avenue Hoarau 18332 Bernard', '0600000182', NULL),
(183, 'M', 'Lebon', 'Élodie', '1969-05-14', 'elodie.lebon178@example.com', 'chemin de Henry 37733 Gilbert-la-Forêt', '0600000183', NULL),
(184, 'M', 'Legrand', 'Adélaïde', '1983-07-03', 'adelaide.legrand179@example.com', '30, rue de Maréchal 78886 Hamon', '0600000184', NULL),
(185, 'M', 'Marion', 'Philippe', '1970-12-25', 'philippe.marion180@example.com', '56, boulevard Isaac Perrin 93178 PelletierBourg', '0600000185', NULL),
(186, 'M', 'Hoarau', 'Susan', '1995-07-23', 'susan.hoarau181@example.com', '7, boulevard Gauthier 37097 BertinVille', '0600000186', NULL),
(187, 'M', 'Roche', 'Caroline', '1988-06-13', 'caroline.roche182@example.com', '6, avenue Claire Pascal 01726 Torres-sur-Adam', '0600000187', NULL),
(188, 'M', 'Mathieu', 'Marthe', '1963-09-30', 'marthe.mathieu183@example.com', '55, rue Stéphane Bourdon 76725 Sainte BenoîtVille', '0600000188', NULL),
(189, 'M', 'Gérard', 'Chantal', '1995-11-21', 'chantal.gerard184@example.com', '37, chemin Blondel 49002 Guillet', '0600000189', NULL),
(190, 'M', 'Caron', 'Marcel', '2006-06-16', 'marcel.caron185@example.com', '100, avenue de Allard 67493 FerrandVille', '0600000190', NULL),
(191, 'M', 'Gaudin', 'René', '2003-06-10', 'rene.gaudin186@example.com', '29, rue de Daniel 42507 Samson', '0600000191', NULL),
(192, 'M', 'Navarro', 'Alexandria', '1961-05-21', 'alexandria.navarro187@example.com', '3, boulevard Élise Vidal 87475 Fischer', '0600000192', NULL),
(193, 'M', 'Godard', 'Constance', '1963-10-05', 'constance.godard188@example.com', '4, rue de Benoit 04298 Bertrand', '0600000193', NULL),
(194, 'M', 'Lebrun', 'Lucy', '1985-11-07', 'lucy.lebrun189@example.com', '35, boulevard de Dos Santos 85659 Saint Noémi', '0600000194', NULL),
(195, 'M', 'Laporte', 'Lucie', '1960-02-04', 'lucie.laporte190@example.com', 'chemin Chrétien 07719 Brun', '0600000195', NULL),
(196, 'M', 'Martel', 'William', '1976-03-13', 'william.martel191@example.com', '609, boulevard Guérin 48595 Pruvost', '0600000196', NULL),
(197, 'M', 'David', 'Rémy', '1997-12-01', 'remy.david192@example.com', '2, chemin de Delmas 53063 Mendès', '0600000197', NULL),
(198, 'M', 'Delorme', 'Dominique', '1991-08-01', 'dominique.delorme193@example.com', '45, avenue Maurice Cousin 72072 Morel', '0600000198', NULL),
(199, 'M', 'Lemaire', 'Édith', '1981-06-03', 'edith.lemaire194@example.com', '402, boulevard de Dijoux 24210 Parent-la-Forêt', '0600000199', NULL),
(200, 'M', 'Grondin', 'Émile', '1986-07-23', 'emile.grondin195@example.com', '619, boulevard René Guichard 83801 Fernandez', '0600000200', NULL),
(201, 'M', 'Jean', 'Sébastien', '2003-06-30', 'sebastien.jean196@example.com', '656, rue Legendre 56135 Didier', '0600000201', NULL),
(202, 'M', 'Joseph', 'Élodie', '1968-07-05', 'elodie.joseph197@example.com', '89, avenue Ribeiro 74152 Lévêque', '0600000202', NULL),
(203, 'M', 'Jourdan', 'Gabrielle', '1996-05-16', 'gabrielle.jourdan198@example.com', 'rue Juliette Delannoy 26716 Guyon', '0600000203', NULL),
(204, 'M', 'Ferreira', 'Bernadette', '1968-12-30', 'bernadette.ferreira199@example.com', 'rue Descamps 22661 Saint Suzannenec', '0600000204', NULL),
(205, 'M', 'Mace', 'Auguste', '1968-02-07', 'auguste.mace200@example.com', '97, rue Normand 61172 Gomezdan', '0600000205', NULL),
(216, 'A', 'Dupont', 'Alice', '1990-06-14', 'alice.dupont@mail.com', '12 Rue de la Liberté, Paris', '0612345678', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `t_raison_rai`
--

CREATE TABLE `t_raison_rai` (
  `rai_id` int(11) NOT NULL,
  `rai_raison` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `t_raison_rai`
--

INSERT INTO `t_raison_rai` (`rai_id`, `rai_raison`) VALUES
(1, 'Maintenance technique'),
(2, 'Evénement externe'),
(3, 'Fermeture exceptionnelle');

-- --------------------------------------------------------

--
-- Table structure for table `t_reservation_res`
--

CREATE TABLE `t_reservation_res` (
  `res_id` int(11) NOT NULL,
  `res_datereservation` date NOT NULL,
  `res_lieu` varchar(45) NOT NULL,
  `res_heuredebut` datetime(1) NOT NULL,
  `res_bilanreservation` varchar(120) NOT NULL,
  `rsc_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `t_reservation_res`
--

INSERT INTO `t_reservation_res` (`res_id`, `res_datereservation`, `res_lieu`, `res_heuredebut`, `res_bilanreservation`, `rsc_id`) VALUES
(213, '2025-12-01', 'Salle 103', '2025-12-01 09:00:00.0', 'RAS', 3),
(214, '2025-12-01', 'Salle 104', '2025-12-01 14:00:00.0', 'RAS', 4),
(215, '2025-12-01', 'Salle 7', '2025-12-01 18:00:00.0', 'RAS', 11),
(216, '2025-12-02', 'Salle 105', '2025-12-02 09:00:00.0', 'RAS', 5),
(217, '2025-12-02', 'Salle 8', '2025-12-02 14:00:00.0', 'RAS', 12),
(218, '2025-12-02', 'Salle 107', '2025-12-02 18:00:00.0', 'RAS', 10),
(219, '2025-12-03', 'Salle 104', '2025-12-03 09:00:00.0', 'RAS', 4),
(220, '2025-12-03', 'Salle 103', '2025-12-03 14:00:00.0', 'RAS', 3),
(221, '2025-12-03', 'Salle 106', '2025-12-03 18:00:00.0', 'RAS', 6),
(222, '2025-12-04', 'Salle 7', '2025-12-04 09:00:00.0', 'RAS', 11),
(223, '2025-12-04', 'Salle 107', '2025-12-04 14:00:00.0', 'RAS', 10),
(224, '2025-12-04', 'Salle 105', '2025-12-04 18:00:00.0', 'RAS', 5),
(225, '2025-12-05', 'Salle 103', '2025-12-05 09:00:00.0', 'RAS', 3),
(226, '2025-12-05', 'Salle 104', '2025-12-05 14:00:00.0', 'RAS', 4),
(227, '2025-12-05', 'Salle 8', '2025-12-05 18:00:00.0', 'RAS', 12),
(228, '2025-12-06', 'Salle 103', '2025-12-06 09:00:00.0', 'RAS', 3),
(229, '2025-12-06', 'Salle 105', '2025-12-06 14:00:00.0', 'RAS', 5),
(230, '2025-12-06', 'Salle 7', '2025-12-06 18:00:00.0', 'RAS', 11),
(231, '2025-12-07', 'Salle 104', '2025-12-07 09:00:00.0', 'RAS', 4),
(232, '2025-12-07', 'Salle 106', '2025-12-07 14:00:00.0', 'RAS', 6),
(233, '2025-12-07', 'Salle 8', '2025-12-07 18:00:00.0', 'RAS', 12),
(234, '2025-12-08', 'Salle 103', '2025-12-08 09:00:00.0', 'RAS', 3),
(235, '2025-12-08', 'Salle 105', '2025-12-08 14:00:00.0', 'RAS', 5),
(236, '2025-12-08', 'Salle 7', '2025-12-08 18:00:00.0', 'RAS', 11),
(237, '2025-12-09', 'Salle 104', '2025-12-09 09:00:00.0', 'RAS', 4),
(238, '2025-12-09', 'Salle 106', '2025-12-09 14:00:00.0', 'RAS', 6),
(239, '2025-12-09', 'Salle 8', '2025-12-09 18:00:00.0', 'RAS', 12),
(240, '2025-12-10', 'Salle 103', '2025-12-10 09:00:00.0', 'RAS', 3),
(241, '2025-12-10', 'Salle 105', '2025-12-10 14:00:00.0', 'RAS', 5),
(242, '2025-12-10', 'Salle 7', '2025-12-10 18:00:00.0', 'RAS', 11),
(243, '2025-12-11', 'Salle 104', '2025-12-11 09:00:00.0', 'RAS', 4),
(244, '2025-12-11', 'Salle 106', '2025-12-11 14:00:00.0', 'RAS', 6),
(245, '2025-12-06', 'Salle 103', '2025-12-06 09:00:00.0', 'RAS', 3),
(246, '2025-12-06', 'Salle 104', '2025-12-06 14:00:00.0', 'RAS', 4),
(247, '2025-12-06', 'Salle 105', '2025-12-06 18:00:00.0', 'RAS', 5),
(248, '2025-12-07', 'Salle 106', '2025-12-07 09:00:00.0', 'RAS', 6),
(249, '2025-12-07', 'Salle 107', '2025-12-07 14:00:00.0', 'RAS', 10),
(250, '2025-12-07', 'Salle 103', '2025-12-07 18:00:00.0', 'RAS', 3),
(251, '2025-12-08', 'Salle 104', '2025-12-08 09:00:00.0', 'RAS', 4),
(252, '2025-12-08', 'Salle 105', '2025-12-08 14:00:00.0', 'RAS', 5),
(253, '2025-12-08', 'Salle 106', '2025-12-08 18:00:00.0', 'RAS', 6),
(254, '2025-12-09', 'Salle 103', '2025-12-09 09:00:00.0', 'RAS', 3),
(255, '2025-12-09', 'Salle 107', '2025-12-09 14:00:00.0', 'RAS', 10),
(256, '2025-12-09', 'Salle 104', '2025-12-09 18:00:00.0', 'RAS', 4),
(257, '2025-12-10', 'Salle 103', '2025-12-10 09:00:00.0', 'RAS', 3),
(258, '2025-12-10', 'Salle 104', '2025-12-10 14:00:00.0', 'RAS', 4),
(259, '2025-12-10', 'Salle 105', '2025-12-10 18:00:00.0', 'RAS', 5),
(260, '2025-12-11', 'Salle 106', '2025-12-11 09:00:00.0', 'RAS', 6),
(261, '2025-12-11', 'Salle 107', '2025-12-11 14:00:00.0', 'RAS', 10),
(262, '2025-12-11', 'Salle 103', '2025-12-11 18:00:00.0', 'RAS', 3),
(263, '2025-12-12', 'Salle 104', '2025-12-12 09:00:00.0', 'RAS', 4),
(264, '2025-12-12', 'Salle 105', '2025-12-12 14:00:00.0', 'RAS', 5),
(265, '2025-12-12', 'Salle 106', '2025-12-12 18:00:00.0', 'RAS', 6),
(266, '2025-12-13', 'Salle 103', '2025-12-13 09:00:00.0', 'RAS', 3),
(267, '2025-12-13', 'Salle 107', '2025-12-13 14:00:00.0', 'RAS', 10),
(268, '2025-12-13', 'Salle 104', '2025-12-13 18:00:00.0', 'RAS', 4),
(269, '2025-12-14', 'Salle 105', '2025-12-14 09:00:00.0', 'RAS', 5),
(270, '2025-12-14', 'Salle 106', '2025-12-14 14:00:00.0', 'RAS', 6),
(271, '2025-12-14', 'Salle 103', '2025-12-14 18:00:00.0', 'RAS', 3),
(272, '2025-12-15', 'Salle 107', '2025-12-15 09:00:00.0', 'RAS', 10),
(273, '2025-12-15', 'Salle 104', '2025-12-15 14:00:00.0', 'RAS', 4),
(274, '2025-12-15', 'Salle 106', '2025-12-15 18:00:00.0', 'RAS', 6),
(275, '2025-12-16', 'Salle 103', '2025-12-16 09:00:00.0', 'RAS', 3),
(276, '2025-12-16', 'Salle 105', '2025-12-16 14:00:00.0', 'RAS', 5),
(277, '2025-12-16', 'Salle 106', '2025-12-16 18:00:00.0', 'RAS', 6),
(278, '2025-12-17', 'Salle 104', '2025-12-17 09:00:00.0', 'RAS', 4),
(279, '2025-12-17', 'Salle 105', '2025-12-17 14:00:00.0', 'RAS', 5),
(280, '2025-12-17', 'Salle 107', '2025-12-17 18:00:00.0', 'RAS', 10),
(281, '2025-12-18', 'Salle 103', '2025-12-18 09:00:00.0', 'RAS', 3),
(282, '2025-12-18', 'Salle 104', '2025-12-18 14:00:00.0', 'RAS', 4),
(283, '2025-12-18', 'Salle 105', '2025-12-18 18:00:00.0', 'RAS', 5),
(284, '2025-12-19', 'Salle 106', '2025-12-19 09:00:00.0', 'RAS', 6),
(285, '2025-12-19', 'Salle 107', '2025-12-19 14:00:00.0', 'RAS', 10),
(286, '2025-12-19', 'Salle 103', '2025-12-19 18:00:00.0', 'RAS', 3),
(287, '2025-12-20', 'Salle 104', '2025-12-20 09:00:00.0', 'RAS', 4),
(288, '2025-12-20', 'Salle 105', '2025-12-20 14:00:00.0', 'RAS', 5),
(289, '2025-12-20', 'Salle 106', '2025-12-20 18:00:00.0', 'RAS', 6),
(290, '2025-12-21', 'Salle 107', '2025-12-21 09:00:00.0', 'RAS', 10),
(291, '2025-12-21', 'Salle 103', '2025-12-21 14:00:00.0', 'RAS', 3),
(292, '2025-12-21', 'Salle 105', '2025-12-21 18:00:00.0', 'RAS', 5),
(293, '2025-12-22', 'Salle 104', '2025-12-22 09:00:00.0', 'RAS', 4),
(294, '2025-12-22', 'Salle 106', '2025-12-22 14:00:00.0', 'RAS', 6),
(295, '2025-12-22', 'Salle 107', '2025-12-22 18:00:00.0', 'RAS', 10),
(296, '2025-12-23', 'Salle 103', '2025-12-23 09:00:00.0', 'RAS', 3),
(297, '2025-12-23', 'Salle 105', '2025-12-23 14:00:00.0', 'RAS', 5),
(298, '2025-12-23', 'Salle 104', '2025-12-23 18:00:00.0', 'RAS', 4),
(299, '2025-12-24', 'Salle 107', '2025-12-24 09:00:00.0', 'RAS', 10),
(300, '2025-12-24', 'Salle 103', '2025-12-24 14:00:00.0', 'RAS', 3),
(301, '2025-12-24', 'Salle 106', '2025-12-24 18:00:00.0', 'RAS', 6),
(302, '2025-12-25', 'Salle 103', '2025-12-25 09:00:00.0', 'RAS', 3),
(303, '2025-12-25', 'Salle 104', '2025-12-25 14:00:00.0', 'RAS', 4),
(304, '2025-12-25', 'Salle 105', '2025-12-25 18:00:00.0', 'RAS', 5),
(305, '2025-12-26', 'Salle 106', '2025-12-26 09:00:00.0', 'RAS', 6),
(306, '2025-12-26', 'Salle 107', '2025-12-26 14:00:00.0', 'RAS', 10),
(307, '2025-12-26', 'Salle 103', '2025-12-26 18:00:00.0', 'RAS', 3),
(308, '2025-12-27', 'Salle 104', '2025-12-27 09:00:00.0', 'RAS', 4),
(309, '2025-12-27', 'Salle 105', '2025-12-27 14:00:00.0', 'RAS', 5),
(310, '2025-12-27', 'Salle 106', '2025-12-27 18:00:00.0', 'RAS', 6),
(311, '2025-12-28', 'Salle 103', '2025-12-28 09:00:00.0', 'RAS', 3),
(312, '2025-12-28', 'Salle 104', '2025-12-28 14:00:00.0', 'RAS', 4),
(313, '2025-12-28', 'Salle 105', '2025-12-28 18:00:00.0', 'RAS', 5),
(314, '2025-12-29', 'Salle 106', '2025-12-29 09:00:00.0', 'RAS', 6),
(315, '2025-12-29', 'Salle 107', '2025-12-29 14:00:00.0', 'RAS', 10),
(316, '2025-12-29', 'Salle 103', '2025-12-29 18:00:00.0', 'RAS', 3),
(317, '2025-12-30', 'Salle 104', '2025-12-30 09:00:00.0', 'RAS', 4),
(318, '2025-12-30', 'Salle 105', '2025-12-30 14:00:00.0', 'RAS', 5),
(319, '2025-12-30', 'Salle 106', '2025-12-30 18:00:00.0', 'RAS', 6),
(320, '2025-12-31', 'Salle 107', '2025-12-31 09:00:00.0', 'RAS', 10),
(321, '2025-12-31', 'Salle 103', '2025-12-31 14:00:00.0', 'RAS', 3),
(322, '2025-12-31', 'Salle 105', '2025-12-31 18:00:00.0', 'RAS', 5),
(323, '2026-01-01', 'Salle 103', '2026-01-01 09:00:00.0', 'RAS', 3),
(324, '2026-01-01', 'Salle 104', '2026-01-01 14:00:00.0', 'RAS', 4),
(325, '2026-01-01', 'Salle 105', '2026-01-01 18:00:00.0', 'RAS', 5),
(326, '2026-01-02', 'Salle 106', '2026-01-02 09:00:00.0', 'RAS', 6),
(327, '2026-01-02', 'Salle 107', '2026-01-02 14:00:00.0', 'RAS', 10),
(328, '2026-01-02', 'Salle 103', '2026-01-02 18:00:00.0', 'RAS', 3),
(329, '2026-01-03', 'Salle 104', '2026-01-03 09:00:00.0', 'RAS', 4),
(330, '2026-01-03', 'Salle 105', '2026-01-03 14:00:00.0', 'RAS', 5),
(331, '2026-01-03', 'Salle 106', '2026-01-03 18:00:00.0', 'RAS', 6),
(332, '2026-01-04', 'Salle 107', '2026-01-04 09:00:00.0', 'RAS', 10),
(333, '2026-01-04', 'Salle 103', '2026-01-04 14:00:00.0', 'RAS', 3),
(334, '2026-01-04', 'Salle 104', '2026-01-04 18:00:00.0', 'RAS', 4),
(335, '2026-01-05', 'Salle 105', '2026-01-05 09:00:00.0', 'RAS', 5),
(336, '2026-01-05', 'Salle 106', '2026-01-05 14:00:00.0', 'RAS', 6),
(337, '2026-01-05', 'Salle 107', '2026-01-05 18:00:00.0', 'RAS', 10),
(338, '2026-01-06', 'Salle 103', '2026-01-06 09:00:00.0', 'RAS', 3),
(339, '2026-01-06', 'Salle 104', '2026-01-06 14:00:00.0', 'RAS', 4),
(340, '2026-01-06', 'Salle 105', '2026-01-06 18:00:00.0', 'RAS', 5),
(341, '2026-01-07', 'Salle 106', '2026-01-07 09:00:00.0', 'RAS', 6),
(342, '2026-01-07', 'Salle 107', '2026-01-07 14:00:00.0', 'RAS', 10),
(343, '2026-01-07', 'Salle 103', '2026-01-07 18:00:00.0', 'RAS', 3),
(344, '2026-01-08', 'Salle 104', '2026-01-08 09:00:00.0', 'RAS', 4),
(345, '2026-01-08', 'Salle 105', '2026-01-08 14:00:00.0', 'RAS', 5),
(346, '2026-01-08', 'Salle 106', '2026-01-08 18:00:00.0', 'RAS', 6),
(347, '2026-01-09', 'Salle 107', '2026-01-09 09:00:00.0', 'RAS', 10),
(348, '2026-01-09', 'Salle 103', '2026-01-09 14:00:00.0', 'RAS', 3),
(349, '2026-01-09', 'Salle 104', '2026-01-09 18:00:00.0', 'RAS', 4),
(350, '2026-01-10', 'Salle 105', '2026-01-10 09:00:00.0', 'RAS', 5),
(351, '2026-01-10', 'Salle 106', '2026-01-10 14:00:00.0', 'RAS', 6),
(352, '2026-01-10', 'Salle 107', '2026-01-10 18:00:00.0', 'RAS', 10),
(353, '2026-01-11', 'Salle 103', '2026-01-11 09:00:00.0', 'RAS', 3),
(354, '2026-01-11', 'Salle 104', '2026-01-11 14:00:00.0', 'RAS', 4),
(355, '2026-01-11', 'Salle 105', '2026-01-11 18:00:00.0', 'RAS', 5),
(356, '2026-01-12', 'Salle 106', '2026-01-12 09:00:00.0', 'RAS', 6),
(357, '2026-01-12', 'Salle 107', '2026-01-12 14:00:00.0', 'RAS', 10),
(358, '2026-01-12', 'Salle 103', '2026-01-12 18:00:00.0', 'RAS', 3),
(359, '2026-01-13', 'Salle 104', '2026-01-13 09:00:00.0', 'RAS', 4),
(360, '2026-01-13', 'Salle 105', '2026-01-13 14:00:00.0', 'RAS', 5),
(361, '2026-01-13', 'Salle 106', '2026-01-13 18:00:00.0', 'RAS', 6),
(362, '2026-01-14', 'Salle 107', '2026-01-14 09:00:00.0', 'RAS', 10),
(363, '2026-01-14', 'Salle 103', '2026-01-14 14:00:00.0', 'RAS', 3),
(364, '2026-01-14', 'Salle 104', '2026-01-14 18:00:00.0', 'RAS', 4),
(365, '2026-01-15', 'Salle 105', '2026-01-15 09:00:00.0', 'RAS', 5),
(366, '2026-01-15', 'Salle 106', '2026-01-15 14:00:00.0', 'RAS', 6),
(367, '2026-01-15', 'Salle 107', '2026-01-15 18:00:00.0', 'RAS', 10),
(368, '2026-01-16', 'Salle 103', '2026-01-16 09:00:00.0', 'RAS', 3),
(369, '2026-01-16', 'Salle 104', '2026-01-16 14:00:00.0', 'RAS', 4),
(370, '2026-01-16', 'Salle 105', '2026-01-16 18:00:00.0', 'RAS', 5),
(371, '2026-01-17', 'Salle 106', '2026-01-17 09:00:00.0', 'RAS', 6),
(372, '2026-01-17', 'Salle 107', '2026-01-17 14:00:00.0', 'RAS', 10),
(373, '2026-01-17', 'Salle 103', '2026-01-17 18:00:00.0', 'RAS', 3),
(374, '2026-01-18', 'Salle 104', '2026-01-18 09:00:00.0', 'RAS', 4),
(375, '2026-01-18', 'Salle 105', '2026-01-18 14:00:00.0', 'RAS', 5),
(376, '2026-01-18', 'Salle 106', '2026-01-18 18:00:00.0', 'RAS', 6),
(377, '2026-01-19', 'Salle 107', '2026-01-19 09:00:00.0', 'RAS', 10),
(378, '2026-01-19', 'Salle 103', '2026-01-19 14:00:00.0', 'RAS', 3),
(379, '2026-01-19', 'Salle 104', '2026-01-19 18:00:00.0', 'RAS', 4),
(380, '2026-01-20', 'Salle 105', '2026-01-20 09:00:00.0', 'RAS', 5),
(381, '2026-01-20', 'Salle 106', '2026-01-20 14:00:00.0', 'RAS', 6),
(382, '2026-01-20', 'Salle 107', '2026-01-20 18:00:00.0', 'RAS', 10),
(383, '2026-01-21', 'Salle 103', '2026-01-21 09:00:00.0', 'RAS', 3),
(384, '2026-01-21', 'Salle 104', '2026-01-21 14:00:00.0', 'RAS', 4),
(385, '2026-01-21', 'Salle 105', '2026-01-21 18:00:00.0', 'RAS', 5),
(386, '2026-01-22', 'Salle 106', '2026-01-22 09:00:00.0', 'RAS', 6),
(387, '2026-01-22', 'Salle 107', '2026-01-22 14:00:00.0', 'RAS', 10),
(388, '2026-01-22', 'Salle 103', '2026-01-22 18:00:00.0', 'RAS', 3),
(389, '2026-01-23', 'Salle 104', '2026-01-23 09:00:00.0', 'RAS', 4),
(390, '2026-01-23', 'Salle 105', '2026-01-23 14:00:00.0', 'RAS', 5),
(391, '2026-01-23', 'Salle 106', '2026-01-23 18:00:00.0', 'RAS', 6),
(392, '2026-01-24', 'Salle 107', '2026-01-24 09:00:00.0', 'RAS', 10),
(393, '2026-01-24', 'Salle 103', '2026-01-24 14:00:00.0', 'RAS', 3),
(394, '2026-01-24', 'Salle 104', '2026-01-24 18:00:00.0', 'RAS', 4),
(395, '2026-01-25', 'Salle 105', '2026-01-25 09:00:00.0', 'RAS', 5),
(396, '2026-01-25', 'Salle 106', '2026-01-25 14:00:00.0', 'RAS', 6),
(397, '2026-01-25', 'Salle 107', '2026-01-25 18:00:00.0', 'RAS', 10),
(398, '2026-01-26', 'Salle 103', '2026-01-26 09:00:00.0', 'RAS', 3),
(399, '2026-01-26', 'Salle 104', '2026-01-26 14:00:00.0', 'RAS', 4),
(400, '2026-01-26', 'Salle 105', '2026-01-26 18:00:00.0', 'RAS', 5),
(401, '2026-01-27', 'Salle 106', '2026-01-27 09:00:00.0', 'RAS', 6),
(402, '2026-01-27', 'Salle 107', '2026-01-27 14:00:00.0', 'RAS', 10),
(403, '2026-01-27', 'Salle 103', '2026-01-27 18:00:00.0', 'RAS', 3),
(404, '2026-01-28', 'Salle 104', '2026-01-28 09:00:00.0', 'RAS', 4),
(405, '2026-01-28', 'Salle 105', '2026-01-28 14:00:00.0', 'RAS', 5),
(406, '2026-01-28', 'Salle 106', '2026-01-28 18:00:00.0', 'RAS', 6),
(407, '2026-01-29', 'Salle 107', '2026-01-29 09:00:00.0', 'RAS', 10),
(408, '2026-01-29', 'Salle 103', '2026-01-29 14:00:00.0', 'RAS', 3),
(409, '2026-01-29', 'Salle 104', '2026-01-29 18:00:00.0', 'RAS', 4),
(410, '2026-01-30', 'Salle 105', '2026-01-30 09:00:00.0', 'RAS', 5),
(411, '2026-01-30', 'Salle 106', '2026-01-30 14:00:00.0', 'RAS', 6),
(412, '2026-01-30', 'Salle 107', '2026-01-30 18:00:00.0', 'RAS', 10),
(413, '2026-01-31', 'Salle 103', '2026-01-31 09:00:00.0', 'RAS', 3),
(414, '2026-01-31', 'Salle 104', '2026-01-31 14:00:00.0', 'RAS', 4),
(415, '2026-01-31', 'Salle 105', '2026-01-31 18:00:00.0', 'RAS', 5),
(416, '2026-02-01', 'Salle 103', '2026-02-01 09:00:00.0', 'RAS', 3),
(417, '2026-02-01', 'Salle 104', '2026-02-01 14:00:00.0', 'RAS', 4),
(418, '2026-02-01', 'Salle 105', '2026-02-01 18:00:00.0', 'RAS', 5),
(419, '2026-02-02', 'Salle 106', '2026-02-02 09:00:00.0', 'RAS', 6),
(420, '2026-02-02', 'Salle 107', '2026-02-02 14:00:00.0', 'RAS', 10),
(421, '2026-02-02', 'Salle 103', '2026-02-02 18:00:00.0', 'RAS', 3),
(422, '2026-02-03', 'Salle 104', '2026-02-03 09:00:00.0', 'RAS', 4),
(423, '2026-02-03', 'Salle 105', '2026-02-03 14:00:00.0', 'RAS', 5),
(424, '2026-02-03', 'Salle 106', '2026-02-03 18:00:00.0', 'RAS', 6),
(425, '2026-02-04', 'Salle 107', '2026-02-04 09:00:00.0', 'RAS', 10),
(426, '2026-02-04', 'Salle 103', '2026-02-04 14:00:00.0', 'RAS', 3),
(427, '2026-02-04', 'Salle 104', '2026-02-04 18:00:00.0', 'RAS', 4),
(428, '2026-02-05', 'Salle 105', '2026-02-05 09:00:00.0', 'RAS', 5),
(429, '2026-02-05', 'Salle 106', '2026-02-05 14:00:00.0', 'RAS', 6),
(430, '2026-02-05', 'Salle 107', '2026-02-05 18:00:00.0', 'RAS', 10),
(431, '2026-02-06', 'Salle 103', '2026-02-06 09:00:00.0', 'RAS', 3),
(432, '2026-02-06', 'Salle 104', '2026-02-06 14:00:00.0', 'RAS', 4),
(433, '2026-02-06', 'Salle 105', '2026-02-06 18:00:00.0', 'RAS', 5),
(434, '2026-02-07', 'Salle 106', '2026-02-07 09:00:00.0', 'RAS', 6),
(435, '2026-02-07', 'Salle 107', '2026-02-07 14:00:00.0', 'RAS', 10),
(436, '2026-02-07', 'Salle 103', '2026-02-07 18:00:00.0', 'RAS', 3),
(437, '2026-02-08', 'Salle 104', '2026-02-08 09:00:00.0', 'RAS', 4),
(438, '2026-02-08', 'Salle 105', '2026-02-08 14:00:00.0', 'RAS', 5),
(439, '2026-02-08', 'Salle 106', '2026-02-08 18:00:00.0', 'RAS', 6),
(440, '2026-02-09', 'Salle 107', '2026-02-09 09:00:00.0', 'RAS', 10),
(441, '2026-02-09', 'Salle 103', '2026-02-09 14:00:00.0', 'RAS', 3),
(442, '2026-02-09', 'Salle 104', '2026-02-09 18:00:00.0', 'RAS', 4),
(443, '2026-02-10', 'Salle 105', '2026-02-10 09:00:00.0', 'RAS', 5),
(444, '2026-02-10', 'Salle 106', '2026-02-10 14:00:00.0', 'RAS', 6),
(445, '2026-02-10', 'Salle 107', '2026-02-10 18:00:00.0', 'RAS', 10),
(446, '2026-02-11', 'Salle 103', '2026-02-11 09:00:00.0', 'RAS', 3),
(447, '2026-02-11', 'Salle 104', '2026-02-11 14:00:00.0', 'RAS', 4),
(448, '2026-02-11', 'Salle 105', '2026-02-11 18:00:00.0', 'RAS', 5),
(449, '2026-02-12', 'Salle 106', '2026-02-12 09:00:00.0', 'RAS', 6),
(450, '2026-02-12', 'Salle 107', '2026-02-12 14:00:00.0', 'RAS', 10),
(451, '2026-02-12', 'Salle 103', '2026-02-12 18:00:00.0', 'RAS', 3),
(452, '2026-02-13', 'Salle 104', '2026-02-13 09:00:00.0', 'RAS', 4),
(453, '2026-02-13', 'Salle 105', '2026-02-13 14:00:00.0', 'RAS', 5),
(454, '2026-02-13', 'Salle 106', '2026-02-13 18:00:00.0', 'RAS', 6),
(455, '2026-02-14', 'Salle 107', '2026-02-14 09:00:00.0', 'RAS', 10),
(456, '2026-02-14', 'Salle 103', '2026-02-14 14:00:00.0', 'RAS', 3),
(457, '2026-02-14', 'Salle 104', '2026-02-14 18:00:00.0', 'RAS', 4),
(458, '2026-02-15', 'Salle 105', '2026-02-15 09:00:00.0', 'RAS', 5),
(459, '2026-02-15', 'Salle 106', '2026-02-15 14:00:00.0', 'RAS', 6),
(460, '2026-02-15', 'Salle 107', '2026-02-15 18:00:00.0', 'RAS', 10),
(461, '2026-02-16', 'Salle 103', '2026-02-16 09:00:00.0', 'RAS', 3),
(462, '2026-02-16', 'Salle 104', '2026-02-16 14:00:00.0', 'RAS', 4),
(463, '2026-02-16', 'Salle 105', '2026-02-16 18:00:00.0', 'RAS', 5),
(464, '2026-02-17', 'Salle 106', '2026-02-17 09:00:00.0', 'RAS', 6),
(465, '2026-02-17', 'Salle 107', '2026-02-17 14:00:00.0', 'RAS', 10),
(466, '2026-02-17', 'Salle 103', '2026-02-17 18:00:00.0', 'RAS', 3),
(467, '2026-02-18', 'Salle 104', '2026-02-18 09:00:00.0', 'RAS', 4),
(468, '2026-02-18', 'Salle 105', '2026-02-18 14:00:00.0', 'RAS', 5),
(469, '2026-02-18', 'Salle 106', '2026-02-18 18:00:00.0', 'RAS', 6),
(470, '2026-02-19', 'Salle 107', '2026-02-19 09:00:00.0', 'RAS - Fin période', 10),
(471, '2026-02-19', 'Salle 103', '2026-02-19 14:00:00.0', 'RAS', 3),
(472, '2026-02-19', 'Salle 104', '2026-02-19 18:00:00.0', 'RAS', 4),
(473, '2026-02-01', 'Salle 103', '2026-02-01 09:00:00.0', 'RAS', 3),
(474, '2026-02-01', 'Salle 104', '2026-02-01 14:00:00.0', 'RAS', 4),
(475, '2026-02-01', 'Salle 105', '2026-02-01 18:00:00.0', 'RAS', 5),
(476, '2026-02-02', 'Salle 106', '2026-02-02 09:00:00.0', 'RAS', 6),
(477, '2026-02-02', 'Salle 107', '2026-02-02 14:00:00.0', 'RAS', 10),
(478, '2026-02-02', 'Salle 103', '2026-02-02 18:00:00.0', 'RAS', 3),
(479, '2026-02-03', 'Salle 104', '2026-02-03 09:00:00.0', 'RAS', 4),
(480, '2026-02-03', 'Salle 105', '2026-02-03 14:00:00.0', 'RAS', 5),
(481, '2026-02-03', 'Salle 106', '2026-02-03 18:00:00.0', 'RAS', 6),
(482, '2026-02-04', 'Salle 107', '2026-02-04 09:00:00.0', 'RAS', 10),
(483, '2026-02-04', 'Salle 103', '2026-02-04 14:00:00.0', 'RAS', 3),
(484, '2026-02-04', 'Salle 104', '2026-02-04 18:00:00.0', 'RAS', 4),
(485, '2026-02-05', 'Salle 105', '2026-02-05 09:00:00.0', 'RAS', 5),
(486, '2026-02-05', 'Salle 106', '2026-02-05 14:00:00.0', 'RAS', 6),
(487, '2026-02-05', 'Salle 107', '2026-02-05 18:00:00.0', 'RAS', 10),
(488, '2026-02-06', 'Salle 103', '2026-02-06 09:00:00.0', 'RAS', 3),
(489, '2026-02-06', 'Salle 104', '2026-02-06 14:00:00.0', 'RAS', 4),
(490, '2026-02-06', 'Salle 105', '2026-02-06 18:00:00.0', 'RAS', 5),
(491, '2026-02-07', 'Salle 106', '2026-02-07 09:00:00.0', 'RAS', 6),
(492, '2026-02-07', 'Salle 107', '2026-02-07 14:00:00.0', 'RAS', 10),
(493, '2026-02-07', 'Salle 103', '2026-02-07 18:00:00.0', 'RAS', 3),
(494, '2026-02-08', 'Salle 104', '2026-02-08 09:00:00.0', 'RAS', 4),
(495, '2026-02-08', 'Salle 105', '2026-02-08 14:00:00.0', 'RAS', 5),
(496, '2026-02-08', 'Salle 106', '2026-02-08 18:00:00.0', 'RAS', 6),
(497, '2026-02-09', 'Salle 107', '2026-02-09 09:00:00.0', 'RAS', 10),
(498, '2026-02-09', 'Salle 103', '2026-02-09 14:00:00.0', 'RAS', 3),
(499, '2026-02-09', 'Salle 104', '2026-02-09 18:00:00.0', 'RAS', 4),
(500, '2026-02-10', 'Salle 105', '2026-02-10 09:00:00.0', 'RAS', 5),
(501, '2026-02-10', 'Salle 106', '2026-02-10 14:00:00.0', 'RAS', 6),
(502, '2026-02-10', 'Salle 107', '2026-02-10 18:00:00.0', 'RAS', 10),
(503, '2026-02-11', 'Salle 103', '2026-02-11 09:00:00.0', 'RAS', 3),
(504, '2026-02-11', 'Salle 104', '2026-02-11 14:00:00.0', 'RAS', 4),
(505, '2026-02-11', 'Salle 105', '2026-02-11 18:00:00.0', 'RAS', 5),
(506, '2026-02-12', 'Salle 106', '2026-02-12 09:00:00.0', 'RAS', 6),
(507, '2026-02-12', 'Salle 107', '2026-02-12 14:00:00.0', 'RAS', 10),
(508, '2026-02-12', 'Salle 103', '2026-02-12 18:00:00.0', 'RAS', 3),
(509, '2026-02-13', 'Salle 104', '2026-02-13 09:00:00.0', 'RAS', 4),
(510, '2026-02-13', 'Salle 105', '2026-02-13 14:00:00.0', 'RAS', 5),
(511, '2026-02-13', 'Salle 106', '2026-02-13 18:00:00.0', 'RAS', 6),
(512, '2026-02-14', 'Salle 107', '2026-02-14 09:00:00.0', 'RAS', 10),
(513, '2026-02-14', 'Salle 103', '2026-02-14 14:00:00.0', 'RAS', 3),
(514, '2026-02-14', 'Salle 104', '2026-02-14 18:00:00.0', 'RAS', 4),
(515, '2026-02-15', 'Salle 105', '2026-02-15 09:00:00.0', 'RAS', 5),
(516, '2026-02-15', 'Salle 106', '2026-02-15 14:00:00.0', 'RAS', 6),
(517, '2026-02-15', 'Salle 107', '2026-02-15 18:00:00.0', 'RAS', 10),
(518, '2026-02-16', 'Salle 103', '2026-02-16 09:00:00.0', 'RAS', 3),
(519, '2026-02-16', 'Salle 104', '2026-02-16 14:00:00.0', 'RAS', 4),
(520, '2026-02-16', 'Salle 105', '2026-02-16 18:00:00.0', 'RAS', 5),
(521, '2026-02-17', 'Salle 106', '2026-02-17 09:00:00.0', 'RAS', 6),
(522, '2026-02-17', 'Salle 107', '2026-02-17 14:00:00.0', 'RAS', 10),
(523, '2026-02-17', 'Salle 103', '2026-02-17 18:00:00.0', 'RAS', 3),
(524, '2026-02-18', 'Salle 104', '2026-02-18 09:00:00.0', 'RAS', 4),
(525, '2026-02-18', 'Salle 105', '2026-02-18 14:00:00.0', 'RAS', 5),
(526, '2026-02-18', 'Salle 106', '2026-02-18 18:00:00.0', 'RAS', 6),
(527, '2026-02-19', 'Salle 107', '2026-02-19 09:00:00.0', 'RAS ', 10),
(528, '2026-02-19', 'Salle 103', '2026-02-19 14:00:00.0', 'RAS', 3),
(529, '2026-02-19', 'Salle 104', '2026-02-19 18:00:00.0', 'RAS', 4),
(530, '2025-11-19', 'Salle 104', '2025-11-19 18:00:00.0', 'RAS', 4);

-- --------------------------------------------------------

--
-- Table structure for table `t_reserver_rsv`
--

CREATE TABLE `t_reserver_rsv` (
  `com_id` int(11) NOT NULL,
  `res_id` int(11) NOT NULL,
  `rsv_role` char(1) NOT NULL,
  `rsv_dateinscription` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `t_reserver_rsv`
--

INSERT INTO `t_reserver_rsv` (`com_id`, `res_id`, `rsv_role`, `rsv_dateinscription`) VALUES
(1, 530, 'A', '2025-11-19'),
(2, 530, 'P', '2025-11-19'),
(3, 530, 'P', '2025-11-19'),
(4, 217, 'A', '2025-11-29'),
(4, 530, 'P', '2025-11-19'),
(5, 530, 'P', '2025-11-19'),
(6, 223, 'A', '2025-12-01'),
(7, 220, 'P', '2025-11-30'),
(8, 215, 'A', '2025-11-28'),
(10, 264, 'A', '2025-12-07'),
(10, 286, 'A', '2025-12-14'),
(11, 221, 'A', '2025-11-30'),
(11, 255, 'A', '2025-12-04'),
(11, 274, 'A', '2025-12-10'),
(11, 311, 'A', '2025-12-23'),
(11, 321, 'A', '2025-12-26'),
(11, 328, 'A', '2025-12-29'),
(11, 376, 'A', '2026-01-14'),
(11, 398, 'A', '2026-01-22'),
(11, 416, 'A', '2026-01-28'),
(11, 473, 'A', '2026-01-28'),
(12, 213, 'A', '2025-11-28'),
(12, 245, 'A', '2025-12-01'),
(12, 258, 'A', '2025-12-05'),
(12, 287, 'A', '2025-12-15'),
(12, 307, 'A', '2025-12-21'),
(12, 338, 'A', '2026-01-02'),
(12, 365, 'A', '2026-01-11'),
(12, 379, 'A', '2026-01-15'),
(12, 389, 'A', '2026-01-19'),
(12, 406, 'A', '2026-01-24'),
(12, 416, 'P', '2026-01-28'),
(12, 473, 'P', '2026-01-28'),
(13, 292, 'A', '2025-12-16'),
(13, 333, 'A', '2025-12-31'),
(13, 347, 'A', '2026-01-05'),
(13, 410, 'A', '2026-01-26'),
(13, 416, 'P', '2026-01-28'),
(13, 473, 'P', '2026-01-28'),
(14, 227, 'A', '2025-12-02'),
(14, 270, 'A', '2025-12-09'),
(14, 277, 'A', '2025-12-11'),
(14, 283, 'A', '2025-12-13'),
(14, 296, 'A', '2025-12-18'),
(14, 301, 'A', '2025-12-19'),
(14, 316, 'A', '2025-12-24'),
(14, 342, 'A', '2026-01-03'),
(14, 353, 'A', '2026-01-07'),
(14, 369, 'A', '2026-01-12'),
(14, 386, 'A', '2026-01-18'),
(14, 401, 'A', '2026-01-23'),
(14, 415, 'A', '2026-01-27'),
(14, 417, 'A', '2026-01-28'),
(14, 474, 'A', '2026-01-28'),
(15, 247, 'A', '2025-12-01'),
(15, 265, 'A', '2025-12-07'),
(15, 294, 'A', '2025-12-17'),
(15, 323, 'A', '2025-12-28'),
(15, 373, 'A', '2026-01-13'),
(15, 382, 'A', '2026-01-16'),
(15, 395, 'A', '2026-01-21'),
(15, 417, 'P', '2026-01-28'),
(15, 474, 'P', '2026-01-28'),
(16, 219, 'P', '2025-11-30'),
(16, 253, 'A', '2025-12-03'),
(16, 288, 'A', '2025-12-15'),
(16, 298, 'A', '2025-12-18'),
(16, 317, 'A', '2025-12-25'),
(16, 367, 'A', '2026-01-11'),
(16, 403, 'A', '2026-01-23'),
(16, 417, 'P', '2026-01-28'),
(16, 474, 'P', '2026-01-28'),
(17, 215, 'P', '2025-11-28'),
(17, 261, 'A', '2025-12-06'),
(17, 304, 'A', '2025-12-20'),
(17, 312, 'A', '2025-12-23'),
(17, 322, 'A', '2025-12-26'),
(17, 326, 'A', '2025-12-29'),
(17, 334, 'A', '2025-12-31'),
(17, 343, 'A', '2026-01-03'),
(17, 349, 'A', '2026-01-05'),
(17, 361, 'A', '2026-01-09'),
(17, 374, 'A', '2026-01-14'),
(17, 394, 'A', '2026-01-20'),
(17, 408, 'A', '2026-01-25'),
(17, 418, 'A', '2026-01-28'),
(17, 475, 'A', '2026-01-28'),
(18, 218, 'P', '2025-11-29'),
(18, 257, 'A', '2025-12-05'),
(18, 272, 'A', '2025-12-10'),
(18, 278, 'A', '2025-12-12'),
(18, 291, 'A', '2025-12-16'),
(18, 308, 'A', '2025-12-22'),
(18, 335, 'A', '2026-01-01'),
(18, 362, 'A', '2026-01-10'),
(18, 383, 'A', '2026-01-17'),
(18, 397, 'A', '2026-01-21'),
(18, 413, 'A', '2026-01-27'),
(18, 418, 'P', '2026-01-28'),
(18, 475, 'P', '2026-01-28'),
(19, 217, 'P', '2025-11-29'),
(19, 249, 'A', '2025-12-02'),
(19, 266, 'A', '2025-12-08'),
(19, 275, 'A', '2025-12-11'),
(19, 282, 'A', '2025-12-13'),
(19, 297, 'A', '2025-12-18'),
(19, 313, 'A', '2025-12-23'),
(19, 329, 'A', '2025-12-30'),
(19, 344, 'A', '2026-01-04'),
(19, 356, 'A', '2026-01-08'),
(19, 372, 'A', '2026-01-13'),
(19, 388, 'A', '2026-01-18'),
(19, 418, 'P', '2026-01-28'),
(19, 475, 'P', '2026-01-28'),
(20, 295, 'A', '2025-12-17'),
(20, 319, 'A', '2025-12-25'),
(20, 380, 'A', '2026-01-16'),
(20, 409, 'A', '2026-01-25'),
(21, 256, 'A', '2025-12-04'),
(21, 269, 'A', '2025-12-09'),
(21, 302, 'A', '2025-12-20'),
(21, 340, 'A', '2026-01-02'),
(21, 352, 'A', '2026-01-06'),
(21, 357, 'A', '2026-01-08'),
(21, 387, 'A', '2026-01-18'),
(21, 404, 'A', '2026-01-24'),
(21, 419, 'A', '2026-01-29'),
(21, 476, 'A', '2026-01-29'),
(22, 246, 'A', '2025-12-01'),
(22, 273, 'A', '2025-12-10'),
(22, 284, 'A', '2025-12-14'),
(22, 310, 'A', '2025-12-22'),
(22, 327, 'A', '2025-12-29'),
(22, 346, 'A', '2026-01-04'),
(22, 363, 'A', '2026-01-10'),
(22, 392, 'A', '2026-01-20'),
(22, 402, 'A', '2026-01-23'),
(22, 419, 'P', '2026-01-29'),
(22, 476, 'P', '2026-01-29'),
(23, 218, 'A', '2025-11-29'),
(23, 299, 'A', '2025-12-19'),
(23, 314, 'A', '2025-12-24'),
(23, 336, 'A', '2026-01-01'),
(23, 354, 'A', '2026-01-07'),
(23, 370, 'A', '2026-01-12'),
(23, 419, 'P', '2026-01-29'),
(23, 476, 'P', '2026-01-29'),
(24, 281, 'A', '2025-12-13'),
(24, 320, 'A', '2025-12-26'),
(24, 332, 'A', '2025-12-31'),
(24, 359, 'A', '2026-01-09'),
(24, 378, 'A', '2026-01-15'),
(24, 414, 'A', '2026-01-27'),
(24, 420, 'A', '2026-01-29'),
(24, 477, 'A', '2026-01-29'),
(25, 226, 'A', '2025-12-02'),
(25, 259, 'A', '2025-12-05'),
(25, 293, 'A', '2025-12-17'),
(25, 341, 'A', '2026-01-03'),
(25, 350, 'A', '2026-01-06'),
(25, 368, 'A', '2026-01-12'),
(25, 384, 'A', '2026-01-17'),
(25, 407, 'A', '2026-01-25'),
(25, 420, 'P', '2026-01-29'),
(25, 477, 'P', '2026-01-29'),
(26, 267, 'A', '2025-12-08'),
(26, 305, 'A', '2025-12-21'),
(26, 330, 'A', '2025-12-30'),
(26, 375, 'A', '2026-01-14'),
(26, 396, 'A', '2026-01-21'),
(26, 420, 'P', '2026-01-29'),
(26, 477, 'P', '2026-01-29'),
(27, 220, 'A', '2025-11-30'),
(27, 254, 'A', '2025-12-04'),
(27, 280, 'A', '2025-12-12'),
(27, 289, 'A', '2025-12-15'),
(27, 358, 'A', '2026-01-08'),
(27, 390, 'A', '2026-01-19'),
(27, 399, 'A', '2026-01-22'),
(27, 421, 'A', '2026-01-29'),
(27, 478, 'A', '2026-01-29'),
(28, 251, 'A', '2025-12-03'),
(28, 263, 'A', '2025-12-07'),
(28, 270, 'P', '2025-12-09'),
(28, 276, 'A', '2025-12-11'),
(28, 318, 'A', '2025-12-25'),
(28, 324, 'A', '2025-12-28'),
(28, 348, 'A', '2026-01-05'),
(28, 371, 'A', '2026-01-13'),
(28, 381, 'A', '2026-01-16'),
(28, 411, 'A', '2026-01-26'),
(28, 421, 'P', '2026-01-29'),
(28, 478, 'P', '2026-01-29'),
(29, 224, 'P', '2025-12-01'),
(29, 283, 'P', '2025-12-13'),
(29, 290, 'A', '2025-12-16'),
(29, 337, 'A', '2026-01-01'),
(29, 366, 'A', '2026-01-11'),
(29, 421, 'P', '2026-01-29'),
(29, 478, 'P', '2026-01-29'),
(30, 309, 'A', '2025-12-22'),
(30, 331, 'A', '2025-12-30'),
(30, 351, 'A', '2026-01-06'),
(31, 260, 'A', '2025-12-06'),
(31, 300, 'A', '2025-12-19'),
(31, 315, 'A', '2025-12-24'),
(31, 345, 'A', '2026-01-04'),
(31, 355, 'A', '2026-01-07'),
(31, 364, 'A', '2026-01-10'),
(31, 385, 'A', '2026-01-17'),
(31, 393, 'A', '2026-01-20'),
(31, 400, 'A', '2026-01-22'),
(31, 405, 'A', '2026-01-24'),
(31, 422, 'A', '2026-01-30'),
(31, 479, 'A', '2026-01-30'),
(32, 271, 'A', '2025-12-09'),
(32, 303, 'A', '2025-12-20'),
(32, 422, 'P', '2026-01-30'),
(32, 479, 'P', '2026-01-30'),
(33, 214, 'A', '2025-11-28'),
(33, 252, 'A', '2025-12-03'),
(33, 258, 'P', '2025-12-05'),
(33, 268, 'A', '2025-12-08'),
(33, 275, 'P', '2025-12-11'),
(33, 279, 'A', '2025-12-12'),
(33, 286, 'P', '2025-12-14'),
(33, 292, 'P', '2025-12-16'),
(33, 296, 'P', '2025-12-18'),
(33, 306, 'A', '2025-12-21'),
(33, 325, 'A', '2025-12-28'),
(33, 339, 'A', '2026-01-02'),
(33, 360, 'A', '2026-01-09'),
(33, 377, 'A', '2026-01-15'),
(33, 391, 'A', '2026-01-19'),
(33, 422, 'P', '2026-01-30'),
(33, 479, 'P', '2026-01-30'),
(34, 245, 'P', '2025-12-01'),
(34, 321, 'P', '2025-12-26'),
(34, 412, 'A', '2026-01-26'),
(34, 423, 'A', '2026-01-30'),
(34, 480, 'A', '2026-01-30'),
(35, 222, 'P', '2025-12-01'),
(35, 423, 'P', '2026-01-30'),
(35, 480, 'P', '2026-01-30'),
(36, 311, 'P', '2025-12-23'),
(36, 423, 'P', '2026-01-30'),
(36, 480, 'P', '2026-01-30'),
(37, 249, 'P', '2025-12-02'),
(37, 264, 'P', '2025-12-07'),
(37, 274, 'P', '2025-12-10'),
(37, 285, 'A', '2025-12-14'),
(37, 291, 'P', '2025-12-16'),
(37, 424, 'A', '2026-01-30'),
(37, 481, 'A', '2026-01-30'),
(38, 216, 'P', '2025-11-29'),
(38, 255, 'P', '2025-12-04'),
(38, 301, 'P', '2025-12-19'),
(38, 338, 'P', '2026-01-02'),
(38, 424, 'P', '2026-01-30'),
(38, 481, 'P', '2026-01-30'),
(39, 219, 'P', '2025-11-30'),
(39, 273, 'P', '2025-12-10'),
(39, 288, 'P', '2025-12-15'),
(39, 294, 'P', '2025-12-17'),
(39, 304, 'P', '2025-12-20'),
(39, 343, 'P', '2026-01-03'),
(39, 358, 'P', '2026-01-08'),
(39, 424, 'P', '2026-01-30'),
(39, 481, 'P', '2026-01-30'),
(40, 282, 'P', '2025-12-13'),
(40, 307, 'P', '2025-12-21'),
(40, 328, 'P', '2025-12-29'),
(40, 336, 'P', '2026-01-01'),
(41, 225, 'A', '2025-12-02'),
(41, 246, 'P', '2025-12-01'),
(41, 253, 'P', '2025-12-03'),
(41, 262, 'A', '2025-12-06'),
(41, 289, 'P', '2025-12-15'),
(41, 316, 'P', '2025-12-24'),
(41, 333, 'P', '2025-12-31'),
(41, 382, 'P', '2026-01-16'),
(41, 394, 'P', '2026-01-20'),
(41, 413, 'P', '2026-01-27'),
(41, 425, 'A', '2026-01-31'),
(41, 482, 'A', '2026-01-31'),
(42, 260, 'P', '2025-12-06'),
(42, 277, 'P', '2025-12-11'),
(42, 295, 'P', '2025-12-17'),
(42, 353, 'P', '2026-01-07'),
(42, 398, 'P', '2026-01-22'),
(42, 425, 'P', '2026-01-31'),
(42, 482, 'P', '2026-01-31'),
(43, 223, 'P', '2025-12-01'),
(43, 312, 'P', '2025-12-23'),
(43, 326, 'P', '2025-12-29'),
(43, 379, 'P', '2026-01-15'),
(43, 406, 'P', '2026-01-24'),
(43, 425, 'P', '2026-01-31'),
(43, 482, 'P', '2026-01-31'),
(44, 248, 'A', '2025-12-02'),
(44, 257, 'P', '2025-12-05'),
(44, 265, 'P', '2025-12-07'),
(44, 272, 'P', '2025-12-10'),
(44, 287, 'P', '2025-12-15'),
(44, 302, 'P', '2025-12-20'),
(44, 323, 'P', '2025-12-28'),
(44, 335, 'P', '2026-01-01'),
(44, 347, 'P', '2026-01-05'),
(44, 362, 'P', '2026-01-10'),
(44, 373, 'P', '2026-01-13'),
(44, 383, 'P', '2026-01-17'),
(44, 397, 'P', '2026-01-21'),
(44, 408, 'P', '2026-01-25'),
(44, 426, 'A', '2026-01-31'),
(44, 483, 'A', '2026-01-31'),
(45, 213, 'P', '2025-11-28'),
(45, 263, 'P', '2025-12-07'),
(45, 278, 'P', '2025-12-12'),
(45, 426, 'P', '2026-01-31'),
(45, 483, 'P', '2026-01-31'),
(46, 308, 'P', '2025-12-22'),
(46, 331, 'P', '2025-12-30'),
(46, 370, 'P', '2026-01-12'),
(46, 389, 'P', '2026-01-19'),
(46, 409, 'P', '2026-01-25'),
(46, 426, 'P', '2026-01-31'),
(46, 483, 'P', '2026-01-31'),
(47, 251, 'P', '2025-12-03'),
(47, 269, 'P', '2025-12-09'),
(47, 293, 'P', '2025-12-17'),
(47, 300, 'P', '2025-12-19'),
(47, 319, 'P', '2025-12-25'),
(47, 344, 'P', '2026-01-04'),
(47, 352, 'P', '2026-01-06'),
(47, 355, 'P', '2026-01-07'),
(47, 365, 'P', '2026-01-11'),
(47, 376, 'P', '2026-01-14'),
(47, 400, 'P', '2026-01-22'),
(47, 404, 'P', '2026-01-24'),
(47, 427, 'A', '2026-01-31'),
(47, 484, 'A', '2026-01-31'),
(48, 226, 'P', '2025-12-02'),
(48, 247, 'P', '2025-12-01'),
(48, 256, 'P', '2025-12-04'),
(48, 266, 'P', '2025-12-08'),
(48, 298, 'P', '2025-12-18'),
(48, 314, 'P', '2025-12-24'),
(48, 361, 'P', '2026-01-09'),
(48, 388, 'P', '2026-01-18'),
(48, 427, 'P', '2026-01-31'),
(48, 484, 'P', '2026-01-31'),
(49, 221, 'P', '2025-11-30'),
(49, 259, 'P', '2025-12-05'),
(49, 322, 'P', '2025-12-26'),
(49, 340, 'P', '2026-01-02'),
(49, 367, 'P', '2026-01-11'),
(49, 378, 'P', '2026-01-15'),
(49, 395, 'P', '2026-01-21'),
(49, 427, 'P', '2026-01-31'),
(49, 484, 'P', '2026-01-31'),
(50, 220, 'P', '2025-11-30'),
(50, 313, 'P', '2025-12-23'),
(51, 284, 'P', '2025-12-14'),
(51, 305, 'P', '2025-12-21'),
(51, 337, 'P', '2026-01-01'),
(51, 428, 'A', '2026-02-01'),
(51, 485, 'A', '2026-02-01'),
(52, 254, 'P', '2025-12-04'),
(52, 273, 'P', '2025-12-10'),
(52, 280, 'P', '2025-12-12'),
(52, 299, 'P', '2025-12-19'),
(52, 309, 'P', '2025-12-22'),
(52, 317, 'P', '2025-12-25'),
(52, 329, 'P', '2025-12-30'),
(52, 342, 'P', '2026-01-03'),
(52, 349, 'P', '2026-01-05'),
(52, 351, 'P', '2026-01-06'),
(52, 356, 'P', '2026-01-08'),
(52, 369, 'P', '2026-01-12'),
(52, 372, 'P', '2026-01-13'),
(52, 374, 'P', '2026-01-14'),
(52, 386, 'P', '2026-01-18'),
(52, 401, 'P', '2026-01-23'),
(52, 410, 'P', '2026-01-26'),
(52, 428, 'P', '2026-02-01'),
(52, 485, 'P', '2026-02-01'),
(53, 334, 'P', '2025-12-31'),
(53, 366, 'P', '2026-01-11'),
(53, 428, 'P', '2026-02-01'),
(53, 485, 'P', '2026-02-01'),
(54, 261, 'P', '2025-12-06'),
(54, 290, 'P', '2025-12-16'),
(54, 297, 'P', '2025-12-18'),
(54, 310, 'P', '2025-12-22'),
(54, 429, 'A', '2026-02-01'),
(54, 486, 'A', '2026-02-01'),
(55, 250, 'P', '2025-12-02'),
(55, 268, 'P', '2025-12-08'),
(55, 281, 'P', '2025-12-13'),
(55, 320, 'P', '2025-12-26'),
(55, 327, 'P', '2025-12-29'),
(55, 346, 'P', '2026-01-04'),
(55, 380, 'P', '2026-01-16'),
(55, 415, 'P', '2026-01-27'),
(55, 429, 'P', '2026-02-01'),
(55, 486, 'P', '2026-02-01'),
(56, 216, 'A', '2025-11-29'),
(56, 245, 'P', '2025-12-01'),
(56, 258, 'P', '2025-12-05'),
(56, 363, 'P', '2026-01-10'),
(56, 429, 'P', '2026-02-01'),
(56, 486, 'P', '2026-02-01'),
(57, 224, 'A', '2025-12-01'),
(57, 267, 'P', '2025-12-08'),
(57, 325, 'P', '2025-12-28'),
(57, 339, 'P', '2026-01-02'),
(57, 385, 'P', '2026-01-17'),
(57, 393, 'P', '2026-01-20'),
(57, 430, 'A', '2026-02-01'),
(57, 487, 'A', '2026-02-01'),
(58, 288, 'P', '2025-12-15'),
(58, 306, 'P', '2025-12-21'),
(58, 332, 'P', '2025-12-31'),
(58, 354, 'P', '2026-01-07'),
(58, 391, 'P', '2026-01-19'),
(58, 430, 'P', '2026-02-01'),
(58, 487, 'P', '2026-02-01'),
(59, 214, 'P', '2025-11-28'),
(59, 252, 'P', '2025-12-03'),
(59, 279, 'P', '2025-12-12'),
(59, 285, 'P', '2025-12-14'),
(59, 318, 'P', '2025-12-25'),
(59, 359, 'P', '2026-01-09'),
(59, 403, 'P', '2026-01-23'),
(59, 411, 'P', '2026-01-26'),
(59, 430, 'P', '2026-02-01'),
(59, 487, 'P', '2026-02-01'),
(60, 220, 'P', '2025-11-30'),
(60, 271, 'P', '2025-12-09'),
(60, 276, 'P', '2025-12-11'),
(60, 303, 'P', '2025-12-20'),
(60, 350, 'P', '2026-01-06'),
(61, 283, 'P', '2025-12-13'),
(61, 324, 'P', '2025-12-28'),
(61, 330, 'P', '2025-12-30'),
(61, 341, 'P', '2026-01-03'),
(61, 348, 'P', '2026-01-05'),
(61, 368, 'P', '2026-01-12'),
(61, 377, 'P', '2026-01-15'),
(61, 387, 'P', '2026-01-18'),
(61, 407, 'P', '2026-01-25'),
(61, 431, 'A', '2026-02-02'),
(61, 488, 'A', '2026-02-02'),
(62, 250, 'A', '2025-12-02'),
(62, 366, 'P', '2026-01-11'),
(62, 414, 'P', '2026-01-27'),
(62, 431, 'P', '2026-02-02'),
(62, 488, 'P', '2026-02-02'),
(63, 247, 'P', '2025-12-01'),
(63, 265, 'P', '2025-12-07'),
(63, 278, 'P', '2025-12-12'),
(63, 284, 'P', '2025-12-14'),
(63, 315, 'P', '2025-12-24'),
(63, 345, 'P', '2026-01-04'),
(63, 364, 'P', '2026-01-10'),
(63, 373, 'P', '2026-01-13'),
(63, 375, 'P', '2026-01-14'),
(63, 384, 'P', '2026-01-17'),
(63, 396, 'P', '2026-01-21'),
(63, 431, 'P', '2026-02-02'),
(63, 488, 'P', '2026-02-02'),
(64, 269, 'P', '2025-12-09'),
(64, 371, 'P', '2026-01-13'),
(64, 392, 'P', '2026-01-20'),
(64, 402, 'P', '2026-01-23'),
(64, 432, 'A', '2026-02-02'),
(64, 489, 'A', '2026-02-02'),
(65, 217, 'P', '2025-11-29'),
(65, 260, 'P', '2025-12-06'),
(65, 296, 'P', '2025-12-18'),
(65, 311, 'P', '2025-12-23'),
(65, 357, 'P', '2026-01-08'),
(65, 432, 'P', '2026-02-02'),
(65, 489, 'P', '2026-02-02'),
(66, 254, 'P', '2025-12-04'),
(66, 262, 'P', '2025-12-06'),
(66, 336, 'P', '2026-01-01'),
(66, 405, 'P', '2026-01-24'),
(66, 432, 'P', '2026-02-02'),
(66, 489, 'P', '2026-02-02'),
(67, 353, 'P', '2026-01-07'),
(67, 381, 'P', '2026-01-16'),
(67, 433, 'A', '2026-02-02'),
(67, 490, 'A', '2026-02-02'),
(68, 286, 'P', '2025-12-14'),
(68, 295, 'P', '2025-12-17'),
(68, 360, 'P', '2026-01-09'),
(68, 399, 'P', '2026-01-22'),
(68, 433, 'P', '2026-02-02'),
(68, 490, 'P', '2026-02-02'),
(69, 292, 'P', '2025-12-16'),
(69, 300, 'P', '2025-12-19'),
(69, 307, 'P', '2025-12-21'),
(69, 328, 'P', '2025-12-29'),
(69, 390, 'P', '2026-01-19'),
(69, 433, 'P', '2026-02-02'),
(69, 490, 'P', '2026-02-02'),
(70, 294, 'P', '2025-12-17'),
(70, 321, 'P', '2025-12-26'),
(70, 333, 'P', '2025-12-31'),
(70, 364, 'P', '2026-01-10'),
(71, 248, 'P', '2025-12-02'),
(71, 268, 'P', '2025-12-08'),
(71, 291, 'P', '2025-12-16'),
(71, 302, 'P', '2025-12-20'),
(71, 317, 'P', '2025-12-25'),
(71, 338, 'P', '2026-01-02'),
(71, 370, 'P', '2026-01-12'),
(71, 412, 'P', '2026-01-26'),
(71, 434, 'A', '2026-02-03'),
(71, 491, 'A', '2026-02-03'),
(72, 255, 'P', '2025-12-04'),
(72, 261, 'P', '2025-12-06'),
(72, 275, 'P', '2025-12-11'),
(72, 304, 'P', '2025-12-20'),
(72, 313, 'P', '2025-12-23'),
(72, 326, 'P', '2025-12-29'),
(72, 345, 'P', '2026-01-04'),
(72, 358, 'P', '2026-01-08'),
(72, 382, 'P', '2026-01-16'),
(72, 383, 'P', '2026-01-17'),
(72, 434, 'P', '2026-02-03'),
(72, 491, 'P', '2026-02-03'),
(73, 225, 'P', '2025-12-02'),
(73, 259, 'P', '2025-12-05'),
(73, 282, 'P', '2025-12-13'),
(73, 308, 'P', '2025-12-22'),
(73, 323, 'P', '2025-12-28'),
(73, 349, 'P', '2026-01-05'),
(73, 357, 'P', '2026-01-08'),
(73, 387, 'P', '2026-01-18'),
(73, 394, 'P', '2026-01-20'),
(73, 405, 'P', '2026-01-24'),
(73, 408, 'P', '2026-01-25'),
(73, 434, 'P', '2026-02-03'),
(73, 491, 'P', '2026-02-03'),
(74, 216, 'P', '2025-11-29'),
(74, 252, 'P', '2025-12-03'),
(74, 299, 'P', '2025-12-19'),
(74, 351, 'P', '2026-01-06'),
(74, 354, 'P', '2026-01-07'),
(74, 396, 'P', '2026-01-21'),
(74, 435, 'A', '2026-02-03'),
(74, 492, 'A', '2026-02-03'),
(75, 246, 'P', '2025-12-01'),
(75, 287, 'P', '2025-12-15'),
(75, 335, 'P', '2026-01-01'),
(75, 343, 'P', '2026-01-03'),
(75, 362, 'P', '2026-01-10'),
(75, 375, 'P', '2026-01-14'),
(75, 435, 'P', '2026-02-03'),
(75, 492, 'P', '2026-02-03'),
(76, 218, 'P', '2025-11-29'),
(76, 267, 'P', '2025-12-08'),
(76, 315, 'P', '2025-12-24'),
(76, 340, 'P', '2026-01-02'),
(76, 379, 'P', '2026-01-15'),
(76, 435, 'P', '2026-02-03'),
(76, 492, 'P', '2026-02-03'),
(77, 257, 'P', '2025-12-05'),
(77, 272, 'P', '2025-12-10'),
(77, 277, 'P', '2025-12-11'),
(77, 305, 'P', '2025-12-21'),
(77, 330, 'P', '2025-12-30'),
(77, 372, 'P', '2026-01-13'),
(77, 381, 'P', '2026-01-16'),
(77, 388, 'P', '2026-01-18'),
(77, 414, 'P', '2026-01-27'),
(77, 436, 'A', '2026-02-03'),
(77, 493, 'A', '2026-02-03'),
(78, 213, 'P', '2025-11-28'),
(78, 263, 'P', '2025-12-07'),
(78, 290, 'P', '2025-12-16'),
(78, 309, 'P', '2025-12-22'),
(78, 327, 'P', '2025-12-29'),
(78, 346, 'P', '2026-01-04'),
(78, 436, 'P', '2026-02-03'),
(78, 493, 'P', '2026-02-03'),
(79, 316, 'P', '2025-12-24'),
(79, 352, 'P', '2026-01-06'),
(79, 366, 'P', '2026-01-11'),
(79, 393, 'P', '2026-01-20'),
(79, 398, 'P', '2026-01-22'),
(79, 406, 'P', '2026-01-24'),
(79, 436, 'P', '2026-02-03'),
(79, 493, 'P', '2026-02-03'),
(80, 227, 'P', '2025-12-02'),
(80, 258, 'P', '2025-12-05'),
(80, 297, 'P', '2025-12-18'),
(80, 339, 'P', '2026-01-02'),
(81, 219, 'A', '2025-11-30'),
(81, 251, 'P', '2025-12-03'),
(81, 303, 'P', '2025-12-20'),
(81, 325, 'P', '2025-12-28'),
(81, 361, 'P', '2026-01-09'),
(81, 376, 'P', '2026-01-14'),
(81, 437, 'A', '2026-02-04'),
(81, 494, 'A', '2026-02-04'),
(82, 288, 'P', '2025-12-15'),
(82, 306, 'P', '2025-12-21'),
(82, 331, 'P', '2025-12-30'),
(82, 370, 'P', '2026-01-12'),
(82, 403, 'P', '2026-01-23'),
(82, 413, 'P', '2026-01-27'),
(82, 437, 'P', '2026-02-04'),
(82, 494, 'P', '2026-02-04'),
(83, 270, 'P', '2025-12-09'),
(83, 322, 'P', '2025-12-26'),
(83, 334, 'P', '2025-12-31'),
(83, 342, 'P', '2026-01-03'),
(83, 355, 'P', '2026-01-07'),
(83, 389, 'P', '2026-01-19'),
(83, 437, 'P', '2026-02-04'),
(83, 494, 'P', '2026-02-04'),
(84, 249, 'P', '2025-12-02'),
(84, 276, 'P', '2025-12-11'),
(84, 283, 'P', '2025-12-13'),
(84, 314, 'P', '2025-12-24'),
(84, 347, 'P', '2026-01-05'),
(84, 365, 'P', '2026-01-11'),
(84, 387, 'P', '2026-01-18'),
(84, 400, 'P', '2026-01-22'),
(84, 438, 'A', '2026-02-04'),
(84, 495, 'A', '2026-02-04'),
(85, 274, 'P', '2025-12-10'),
(85, 280, 'P', '2025-12-12'),
(85, 310, 'P', '2025-12-22'),
(85, 337, 'P', '2026-01-01'),
(85, 371, 'P', '2026-01-13'),
(85, 397, 'P', '2026-01-21'),
(85, 438, 'P', '2026-02-04'),
(85, 495, 'P', '2026-02-04'),
(86, 293, 'P', '2025-12-17'),
(86, 319, 'P', '2025-12-25'),
(86, 438, 'P', '2026-02-04'),
(86, 495, 'P', '2026-02-04'),
(87, 214, 'P', '2025-11-28'),
(87, 374, 'P', '2026-01-14'),
(87, 392, 'P', '2026-01-20'),
(87, 410, 'P', '2026-01-26'),
(87, 439, 'A', '2026-02-04'),
(87, 496, 'A', '2026-02-04'),
(88, 223, 'P', '2025-12-01'),
(88, 246, 'P', '2025-12-01'),
(88, 264, 'P', '2025-12-07'),
(88, 281, 'P', '2025-12-13'),
(88, 329, 'P', '2025-12-30'),
(88, 351, 'P', '2026-01-06'),
(88, 357, 'P', '2026-01-08'),
(88, 378, 'P', '2026-01-15'),
(88, 404, 'P', '2026-01-24'),
(88, 439, 'P', '2026-02-04'),
(88, 496, 'P', '2026-02-04'),
(89, 271, 'P', '2025-12-09'),
(89, 312, 'P', '2025-12-23'),
(89, 344, 'P', '2026-01-04'),
(89, 349, 'P', '2026-01-05'),
(89, 369, 'P', '2026-01-12'),
(89, 385, 'P', '2026-01-17'),
(89, 415, 'P', '2026-01-27'),
(89, 439, 'P', '2026-02-04'),
(89, 496, 'P', '2026-02-04'),
(90, 222, 'A', '2025-12-01'),
(90, 266, 'P', '2025-12-08'),
(90, 318, 'P', '2025-12-25'),
(90, 324, 'P', '2025-12-28'),
(90, 386, 'P', '2026-01-18'),
(90, 409, 'P', '2026-01-25'),
(91, 257, 'P', '2025-12-05'),
(91, 279, 'P', '2025-12-12'),
(91, 295, 'P', '2025-12-17'),
(91, 309, 'P', '2025-12-22'),
(91, 320, 'P', '2025-12-26'),
(91, 345, 'P', '2026-01-04'),
(91, 354, 'P', '2026-01-07'),
(91, 364, 'P', '2026-01-10'),
(91, 390, 'P', '2026-01-19'),
(91, 402, 'P', '2026-01-23'),
(91, 414, 'P', '2026-01-27'),
(91, 440, 'A', '2026-02-05'),
(91, 497, 'A', '2026-02-05'),
(92, 216, 'P', '2025-11-29'),
(92, 248, 'P', '2025-12-02'),
(92, 285, 'P', '2025-12-14'),
(92, 301, 'P', '2025-12-19'),
(92, 334, 'P', '2025-12-31'),
(92, 360, 'P', '2026-01-09'),
(92, 375, 'P', '2026-01-14'),
(92, 395, 'P', '2026-01-21'),
(92, 399, 'P', '2026-01-22'),
(92, 440, 'P', '2026-02-05'),
(92, 497, 'P', '2026-02-05'),
(93, 253, 'P', '2025-12-03'),
(93, 264, 'P', '2025-12-07'),
(93, 273, 'P', '2025-12-10'),
(93, 289, 'P', '2025-12-15'),
(93, 298, 'P', '2025-12-18'),
(93, 339, 'P', '2026-01-02'),
(93, 367, 'P', '2026-01-11'),
(93, 380, 'P', '2026-01-16'),
(93, 412, 'P', '2026-01-26'),
(93, 440, 'P', '2026-02-05'),
(93, 497, 'P', '2026-02-05'),
(94, 304, 'P', '2025-12-20'),
(94, 330, 'P', '2025-12-30'),
(94, 342, 'P', '2026-01-03'),
(94, 356, 'P', '2026-01-08'),
(94, 441, 'A', '2026-02-05'),
(94, 498, 'A', '2026-02-05'),
(95, 297, 'P', '2025-12-18'),
(95, 315, 'P', '2025-12-24'),
(95, 322, 'P', '2025-12-26'),
(95, 348, 'P', '2026-01-05'),
(95, 441, 'P', '2026-02-05'),
(95, 498, 'P', '2026-02-05'),
(96, 261, 'P', '2025-12-06'),
(96, 313, 'P', '2025-12-23'),
(96, 332, 'P', '2025-12-31'),
(96, 359, 'P', '2026-01-09'),
(96, 381, 'P', '2026-01-16'),
(96, 384, 'P', '2026-01-17'),
(96, 401, 'P', '2026-01-23'),
(96, 408, 'P', '2026-01-25'),
(96, 441, 'P', '2026-02-05'),
(96, 498, 'P', '2026-02-05'),
(97, 341, 'P', '2026-01-03'),
(97, 350, 'P', '2026-01-06'),
(97, 363, 'P', '2026-01-10'),
(97, 368, 'P', '2026-01-12'),
(97, 411, 'P', '2026-01-26'),
(97, 442, 'A', '2026-02-05'),
(97, 499, 'A', '2026-02-05'),
(98, 267, 'P', '2025-12-08'),
(98, 336, 'P', '2026-01-01'),
(98, 377, 'P', '2026-01-15'),
(98, 405, 'P', '2026-01-24'),
(98, 442, 'P', '2026-02-05'),
(98, 499, 'P', '2026-02-05'),
(99, 215, 'P', '2025-11-28'),
(99, 226, 'P', '2025-12-02'),
(99, 262, 'P', '2025-12-06'),
(99, 279, 'P', '2025-12-12'),
(99, 407, 'P', '2026-01-25'),
(99, 442, 'P', '2026-02-05'),
(99, 499, 'P', '2026-02-05'),
(100, 393, 'P', '2026-01-20'),
(101, 213, 'P', '2025-11-28'),
(101, 285, 'P', '2025-12-14'),
(101, 306, 'P', '2025-12-21'),
(101, 327, 'P', '2025-12-29'),
(101, 396, 'P', '2026-01-21'),
(101, 443, 'A', '2026-02-06'),
(101, 500, 'A', '2026-02-06'),
(102, 292, 'P', '2025-12-16'),
(102, 318, 'P', '2025-12-25'),
(102, 325, 'P', '2025-12-28'),
(102, 361, 'P', '2026-01-09'),
(102, 379, 'P', '2026-01-15'),
(102, 391, 'P', '2026-01-19'),
(102, 443, 'P', '2026-02-06'),
(102, 500, 'P', '2026-02-06'),
(103, 372, 'P', '2026-01-13'),
(103, 443, 'P', '2026-02-06'),
(103, 500, 'P', '2026-02-06'),
(104, 444, 'A', '2026-02-06'),
(104, 501, 'A', '2026-02-06'),
(105, 444, 'P', '2026-02-06'),
(105, 501, 'P', '2026-02-06'),
(106, 444, 'P', '2026-02-06'),
(106, 501, 'P', '2026-02-06'),
(107, 445, 'A', '2026-02-06'),
(107, 502, 'A', '2026-02-06'),
(108, 445, 'P', '2026-02-06'),
(108, 502, 'P', '2026-02-06'),
(109, 445, 'P', '2026-02-06'),
(109, 502, 'P', '2026-02-06'),
(110, 217, 'P', '2025-11-29'),
(111, 446, 'A', '2026-02-07'),
(111, 503, 'A', '2026-02-07'),
(112, 446, 'P', '2026-02-07'),
(112, 503, 'P', '2026-02-07'),
(113, 446, 'P', '2026-02-07'),
(113, 503, 'P', '2026-02-07'),
(114, 224, 'P', '2025-12-01'),
(114, 447, 'A', '2026-02-07'),
(114, 504, 'A', '2026-02-07'),
(115, 447, 'P', '2026-02-07'),
(115, 504, 'P', '2026-02-07'),
(116, 447, 'P', '2026-02-07'),
(116, 504, 'P', '2026-02-07'),
(117, 448, 'A', '2026-02-07'),
(117, 505, 'A', '2026-02-07'),
(118, 222, 'P', '2025-12-01'),
(118, 448, 'P', '2026-02-07'),
(118, 505, 'P', '2026-02-07'),
(119, 448, 'P', '2026-02-07'),
(119, 505, 'P', '2026-02-07'),
(121, 449, 'A', '2026-02-08'),
(121, 506, 'A', '2026-02-08'),
(122, 226, 'P', '2025-12-02'),
(122, 449, 'P', '2026-02-08'),
(122, 506, 'P', '2026-02-08'),
(123, 221, 'P', '2025-11-30'),
(123, 449, 'P', '2026-02-08'),
(123, 506, 'P', '2026-02-08'),
(124, 450, 'A', '2026-02-08'),
(124, 507, 'A', '2026-02-08'),
(125, 450, 'P', '2026-02-08'),
(125, 507, 'P', '2026-02-08'),
(126, 450, 'P', '2026-02-08'),
(126, 507, 'P', '2026-02-08'),
(127, 451, 'A', '2026-02-08'),
(127, 508, 'A', '2026-02-08'),
(128, 451, 'P', '2026-02-08'),
(128, 508, 'P', '2026-02-08'),
(129, 451, 'P', '2026-02-08'),
(129, 508, 'P', '2026-02-08'),
(131, 227, 'P', '2025-12-02'),
(131, 452, 'A', '2026-02-09'),
(131, 509, 'A', '2026-02-09'),
(132, 224, 'P', '2025-12-01'),
(132, 452, 'P', '2026-02-09'),
(132, 509, 'P', '2026-02-09'),
(133, 220, 'P', '2025-11-30'),
(133, 452, 'P', '2026-02-09'),
(133, 509, 'P', '2026-02-09'),
(134, 453, 'A', '2026-02-09'),
(134, 510, 'A', '2026-02-09'),
(135, 453, 'P', '2026-02-09'),
(135, 510, 'P', '2026-02-09'),
(136, 453, 'P', '2026-02-09'),
(136, 510, 'P', '2026-02-09'),
(137, 454, 'A', '2026-02-09'),
(137, 511, 'A', '2026-02-09'),
(138, 454, 'P', '2026-02-09'),
(138, 511, 'P', '2026-02-09'),
(139, 454, 'P', '2026-02-09'),
(139, 511, 'P', '2026-02-09'),
(140, 218, 'P', '2025-11-29'),
(141, 455, 'A', '2026-02-10'),
(141, 512, 'A', '2026-02-10'),
(142, 214, 'P', '2025-11-28'),
(142, 455, 'P', '2026-02-10'),
(142, 512, 'P', '2026-02-10'),
(143, 455, 'P', '2026-02-10'),
(143, 512, 'P', '2026-02-10'),
(144, 456, 'A', '2026-02-10'),
(144, 513, 'A', '2026-02-10'),
(145, 456, 'P', '2026-02-10'),
(145, 513, 'P', '2026-02-10'),
(146, 456, 'P', '2026-02-10'),
(146, 513, 'P', '2026-02-10'),
(147, 225, 'P', '2025-12-02'),
(147, 457, 'A', '2026-02-10'),
(147, 514, 'A', '2026-02-10'),
(148, 457, 'P', '2026-02-10'),
(148, 514, 'P', '2026-02-10'),
(149, 457, 'P', '2026-02-10'),
(149, 514, 'P', '2026-02-10'),
(150, 216, 'P', '2025-11-29'),
(151, 458, 'A', '2026-02-11'),
(151, 515, 'A', '2026-02-11'),
(152, 223, 'P', '2025-12-01'),
(152, 458, 'P', '2026-02-11'),
(152, 515, 'P', '2026-02-11'),
(153, 458, 'P', '2026-02-11'),
(153, 515, 'P', '2026-02-11'),
(154, 459, 'A', '2026-02-11'),
(154, 516, 'A', '2026-02-11'),
(155, 459, 'P', '2026-02-11'),
(155, 516, 'P', '2026-02-11'),
(156, 459, 'P', '2026-02-11'),
(156, 516, 'P', '2026-02-11'),
(157, 460, 'A', '2026-02-11'),
(157, 517, 'A', '2026-02-11'),
(158, 460, 'P', '2026-02-11'),
(158, 517, 'P', '2026-02-11'),
(159, 460, 'P', '2026-02-11'),
(159, 517, 'P', '2026-02-11'),
(160, 227, 'P', '2025-12-02'),
(161, 461, 'A', '2026-02-12'),
(161, 518, 'A', '2026-02-12'),
(162, 461, 'P', '2026-02-12'),
(162, 518, 'P', '2026-02-12'),
(163, 461, 'P', '2026-02-12'),
(163, 518, 'P', '2026-02-12'),
(164, 462, 'A', '2026-02-12'),
(164, 519, 'A', '2026-02-12'),
(165, 462, 'P', '2026-02-12'),
(165, 519, 'P', '2026-02-12'),
(166, 462, 'P', '2026-02-12'),
(166, 519, 'P', '2026-02-12'),
(167, 463, 'A', '2026-02-12'),
(167, 520, 'A', '2026-02-12'),
(168, 463, 'P', '2026-02-12'),
(168, 520, 'P', '2026-02-12'),
(169, 463, 'P', '2026-02-12'),
(169, 520, 'P', '2026-02-12'),
(171, 464, 'A', '2026-02-13'),
(171, 521, 'A', '2026-02-13'),
(172, 464, 'P', '2026-02-13'),
(172, 521, 'P', '2026-02-13'),
(173, 464, 'P', '2026-02-13'),
(173, 521, 'P', '2026-02-13'),
(174, 465, 'A', '2026-02-13'),
(174, 522, 'A', '2026-02-13'),
(175, 465, 'P', '2026-02-13'),
(175, 522, 'P', '2026-02-13'),
(176, 465, 'P', '2026-02-13'),
(176, 522, 'P', '2026-02-13'),
(177, 466, 'A', '2026-02-13'),
(177, 523, 'A', '2026-02-13'),
(178, 466, 'P', '2026-02-13'),
(178, 523, 'P', '2026-02-13'),
(179, 466, 'P', '2026-02-13'),
(179, 523, 'P', '2026-02-13'),
(181, 467, 'A', '2026-02-14'),
(181, 524, 'A', '2026-02-14'),
(182, 467, 'P', '2026-02-14'),
(182, 524, 'P', '2026-02-14'),
(183, 467, 'P', '2026-02-14'),
(183, 524, 'P', '2026-02-14'),
(184, 468, 'A', '2026-02-14'),
(184, 525, 'A', '2026-02-14'),
(185, 468, 'P', '2026-02-14'),
(185, 525, 'P', '2026-02-14'),
(186, 468, 'P', '2026-02-14'),
(186, 525, 'P', '2026-02-14'),
(187, 469, 'A', '2026-02-14'),
(187, 526, 'A', '2026-02-14'),
(188, 469, 'P', '2026-02-14'),
(188, 526, 'P', '2026-02-14'),
(189, 469, 'P', '2026-02-14'),
(189, 526, 'P', '2026-02-14'),
(191, 470, 'A', '2026-02-15'),
(191, 527, 'A', '2026-02-15'),
(192, 470, 'P', '2026-02-15'),
(192, 527, 'P', '2026-02-15'),
(193, 470, 'P', '2026-02-15'),
(193, 527, 'P', '2026-02-15'),
(194, 471, 'A', '2026-02-15'),
(194, 528, 'A', '2026-02-15'),
(195, 471, 'P', '2026-02-15'),
(195, 528, 'P', '2026-02-15'),
(196, 471, 'P', '2026-02-15'),
(196, 528, 'P', '2026-02-15'),
(197, 472, 'A', '2026-02-15'),
(197, 529, 'A', '2026-02-15'),
(198, 472, 'P', '2026-02-15'),
(198, 529, 'P', '2026-02-15'),
(199, 472, 'P', '2026-02-15'),
(199, 529, 'P', '2026-02-15');

-- --------------------------------------------------------

--
-- Table structure for table `t_ressource_rsc`
--

CREATE TABLE `t_ressource_rsc` (
  `rsc_id` int(11) NOT NULL,
  `rsc_salleid` int(11) NOT NULL,
  `rsc_jaugemin` int(11) NOT NULL,
  `rsc_jaugemax` int(11) NOT NULL,
  `rsc_photo` varchar(120) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `t_ressource_rsc`
--

INSERT INTO `t_ressource_rsc` (`rsc_id`, `rsc_salleid`, `rsc_jaugemin`, `rsc_jaugemax`, `rsc_photo`) VALUES
(3, 103, 2, 6, 'salle_default.jpg'),
(4, 104, 2, 6, 'salle_default.jpg'),
(5, 105, 2, 6, 'salle_default.jpg'),
(6, 106, 2, 6, 'salle_default.jpg'),
(10, 107, 2, 6, 'salle_default.jpg'),
(11, 7, 2, 6, 'salle_default.jpg'),
(12, 8, 2, 6, 'salle_default.jpg');

--
-- Triggers `t_ressource_rsc`
--
DELIMITER $$
CREATE TRIGGER `trg_check_jauge_before_insert` BEFORE INSERT ON `t_ressource_rsc` FOR EACH ROW BEGIN
    IF NEW.rsc_jaugemin < 2 OR NEW.rsc_jaugemax > 6 OR NEW.rsc_jaugemin > NEW.rsc_jaugemax THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Jauges invalides : min >= 2, max <= 6 et max >= min.';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_jauge_rsc` BEFORE INSERT ON `t_ressource_rsc` FOR EACH ROW BEGIN
    IF NEW.rsc_jaugemin < 2 
       OR NEW.rsc_jaugemax > 6 
       OR NEW.rsc_jaugemin > NEW.rsc_jaugemax THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Jauges invalides : min >= 2, max <= 6 et max >= min.';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_rsc_photo_default` BEFORE INSERT ON `t_ressource_rsc` FOR EACH ROW BEGIN
    IF NEW.rsc_photo IS NULL OR NEW.rsc_photo = '' THEN
        SET NEW.rsc_photo = 'salle_default.jpg';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `t_reunion_reu`
--

CREATE TABLE `t_reunion_reu` (
  `reu_id` int(11) NOT NULL,
  `reu_reunion` varchar(120) NOT NULL,
  `reu_date` date NOT NULL,
  `reu_heuredebut` datetime(1) NOT NULL,
  `reu_heurefin` datetime(1) NOT NULL,
  `reu_lieu` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `t_reunion_reu`
--

INSERT INTO `t_reunion_reu` (`reu_id`, `reu_reunion`, `reu_date`, `reu_heuredebut`, `reu_heurefin`, `reu_lieu`) VALUES
(1, 'Réunion Projet Alpha', '2025-10-10', '2025-10-10 09:00:00.0', '2025-10-10 11:00:00.0', 'Salle 101'),
(2, 'Atelier Technique Beta', '2025-10-12', '2025-10-12 14:00:00.0', '2025-10-12 16:00:00.0', 'Salle 102'),
(3, 'Assemblée Générale Gamma', '2025-10-15', '2025-10-15 10:00:00.0', '2025-10-15 13:00:00.0', 'Salle 103'),
(4, 'Réunion_Test_Proc', '2025-10-10', '2025-10-10 09:00:00.0', '2025-10-10 11:00:00.0', 'Salle A');

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_membre_mem`
-- (See below for the actual view)
--
CREATE TABLE `v_membre_mem` (
`com_id` int(11)
,`com_pseudo` varchar(20)
,`com_etat` tinyint(4)
,`pro_nom` varchar(60)
,`pro_prenom` varchar(60)
,`pro_mail` varchar(200)
,`pro_telmob` varchar(12)
,`pro_datedenaissance` date
,`pro_role` char(1)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_reservations_res`
-- (See below for the actual view)
--
CREATE TABLE `v_reservations_res` (
`res_id` int(11)
,`res_datereservation` date
,`res_heuredebut` datetime(1)
,`res_lieu` varchar(45)
,`salle` int(11)
,`responsable` varchar(20)
,`participants` mediumtext
);

-- --------------------------------------------------------

--
-- Structure for view `v_membre_mem`
--
DROP TABLE IF EXISTS `v_membre_mem`;

CREATE ALGORITHM=UNDEFINED DEFINER=`e22501948sql`@`%` SQL SECURITY DEFINER VIEW `v_membre_mem`  AS SELECT `c`.`com_id` AS `com_id`, `c`.`com_pseudo` AS `com_pseudo`, `c`.`com_etat` AS `com_etat`, `p`.`pro_nom` AS `pro_nom`, `p`.`pro_prenom` AS `pro_prenom`, `p`.`pro_mail` AS `pro_mail`, `p`.`pro_telmob` AS `pro_telmob`, `p`.`pro_datedenaissance` AS `pro_datedenaissance`, `p`.`pro_role` AS `pro_role` FROM (`t_compte_com` `c` left join `t_profil_pro` `p` on(`p`.`com_id` = `c`.`com_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_reservations_res`
--
DROP TABLE IF EXISTS `v_reservations_res`;

CREATE ALGORITHM=UNDEFINED DEFINER=`e22501948sql`@`%` SQL SECURITY DEFINER VIEW `v_reservations_res`  AS SELECT `r`.`res_id` AS `res_id`, `r`.`res_datereservation` AS `res_datereservation`, `r`.`res_heuredebut` AS `res_heuredebut`, `r`.`res_lieu` AS `res_lieu`, `rc`.`rsc_salleid` AS `salle`, `resp`.`com_pseudo` AS `responsable`, group_concat(concat(`u`.`com_pseudo`,' (',`rv`.`rsv_role`,')') order by `u`.`com_pseudo` ASC separator ', ') AS `participants` FROM (((((`t_reservation_res` `r` join `t_ressource_rsc` `rc` on(`rc`.`rsc_id` = `r`.`rsc_id`)) left join `t_reserver_rsv` `rv_resp` on(`rv_resp`.`res_id` = `r`.`res_id` and `rv_resp`.`rsv_role` = 'A')) left join `t_compte_com` `resp` on(`resp`.`com_id` = `rv_resp`.`com_id`)) left join `t_reserver_rsv` `rv` on(`rv`.`res_id` = `r`.`res_id`)) left join `t_compte_com` `u` on(`u`.`com_id` = `rv`.`com_id`)) GROUP BY `r`.`res_id` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `t_actualite_act`
--
ALTER TABLE `t_actualite_act`
  ADD PRIMARY KEY (`act_id`),
  ADD KEY `fk_t_actualite_act_t_compte_com2_idx` (`com_id`);

--
-- Indexes for table `t_compte_com`
--
ALTER TABLE `t_compte_com`
  ADD PRIMARY KEY (`com_id`),
  ADD UNIQUE KEY `com_id_UNIQUE` (`com_id`),
  ADD UNIQUE KEY `com_pseudo_UNIQUE` (`com_pseudo`);

--
-- Indexes for table `t_document_doc`
--
ALTER TABLE `t_document_doc`
  ADD PRIMARY KEY (`doc_id`),
  ADD KEY `fk_t_document_doc_t_reunion_reu1_idx` (`reu_id`);

--
-- Indexes for table `t_indisponibilite_ids`
--
ALTER TABLE `t_indisponibilite_ids`
  ADD PRIMARY KEY (`ids_id`),
  ADD KEY `fk_t_indisponibilite_ids_t_raison_rai2_idx` (`rai_id`);

--
-- Indexes for table `t_indisponible_ind`
--
ALTER TABLE `t_indisponible_ind`
  ADD PRIMARY KEY (`rsc_id`,`ids_id`),
  ADD KEY `fk_t_ressource_rsc_has_t_indisponibilite_ids_t_indisponibil_idx` (`ids_id`),
  ADD KEY `fk_t_ressource_rsc_has_t_indisponibilite_ids_t_ressource_rs_idx` (`rsc_id`);

--
-- Indexes for table `t_messageinviter_mei`
--
ALTER TABLE `t_messageinviter_mei`
  ADD PRIMARY KEY (`mei_id`),
  ADD UNIQUE KEY `mei_id_UNIQUE` (`mei_id`),
  ADD UNIQUE KEY `mei_code` (`mei_code`),
  ADD KEY `fk_t_messageinviter_mei_t_compte_com2_idx` (`com_id`);

--
-- Indexes for table `t_participer_par`
--
ALTER TABLE `t_participer_par`
  ADD PRIMARY KEY (`reu_id`,`com_id`),
  ADD KEY `fk_t_resevation_res_has_t_reunion_reu_t_reunion_reu1_idx` (`reu_id`),
  ADD KEY `fk_t_participer_par_t_compte_com1_idx` (`com_id`);

--
-- Indexes for table `t_profil_pro`
--
ALTER TABLE `t_profil_pro`
  ADD PRIMARY KEY (`com_id`),
  ADD UNIQUE KEY `pro_telmob_UNIQUE` (`pro_telmob`),
  ADD KEY `fk_t_profil_pro_t_compte_com1_idx` (`com_id`);

--
-- Indexes for table `t_raison_rai`
--
ALTER TABLE `t_raison_rai`
  ADD PRIMARY KEY (`rai_id`);

--
-- Indexes for table `t_reservation_res`
--
ALTER TABLE `t_reservation_res`
  ADD PRIMARY KEY (`res_id`),
  ADD KEY `fk_t_resevation_res_t_ressource_rsc1_idx` (`rsc_id`);

--
-- Indexes for table `t_reserver_rsv`
--
ALTER TABLE `t_reserver_rsv`
  ADD PRIMARY KEY (`com_id`,`res_id`),
  ADD KEY `fk_t_compte_com_has_t_resevation_res_t_resevation_res1_idx` (`res_id`),
  ADD KEY `fk_t_compte_com_has_t_resevation_res_t_compte_com1_idx` (`com_id`);

--
-- Indexes for table `t_ressource_rsc`
--
ALTER TABLE `t_ressource_rsc`
  ADD PRIMARY KEY (`rsc_id`);

--
-- Indexes for table `t_reunion_reu`
--
ALTER TABLE `t_reunion_reu`
  ADD PRIMARY KEY (`reu_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `t_actualite_act`
--
ALTER TABLE `t_actualite_act`
  MODIFY `act_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `t_compte_com`
--
ALTER TABLE `t_compte_com`
  MODIFY `com_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=230;

--
-- AUTO_INCREMENT for table `t_document_doc`
--
ALTER TABLE `t_document_doc`
  MODIFY `doc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `t_indisponibilite_ids`
--
ALTER TABLE `t_indisponibilite_ids`
  MODIFY `ids_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `t_messageinviter_mei`
--
ALTER TABLE `t_messageinviter_mei`
  MODIFY `mei_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `t_raison_rai`
--
ALTER TABLE `t_raison_rai`
  MODIFY `rai_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `t_reservation_res`
--
ALTER TABLE `t_reservation_res`
  MODIFY `res_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=531;

--
-- AUTO_INCREMENT for table `t_ressource_rsc`
--
ALTER TABLE `t_ressource_rsc`
  MODIFY `rsc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `t_reunion_reu`
--
ALTER TABLE `t_reunion_reu`
  MODIFY `reu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `t_actualite_act`
--
ALTER TABLE `t_actualite_act`
  ADD CONSTRAINT `fk_t_actualite_act_t_compte_com2` FOREIGN KEY (`com_id`) REFERENCES `t_compte_com` (`com_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `t_document_doc`
--
ALTER TABLE `t_document_doc`
  ADD CONSTRAINT `fk_t_document_doc_t_reunion_reu1` FOREIGN KEY (`reu_id`) REFERENCES `t_reunion_reu` (`reu_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `t_indisponibilite_ids`
--
ALTER TABLE `t_indisponibilite_ids`
  ADD CONSTRAINT `fk_t_indisponibilite_ids_t_raison_rai2` FOREIGN KEY (`rai_id`) REFERENCES `t_raison_rai` (`rai_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `t_indisponible_ind`
--
ALTER TABLE `t_indisponible_ind`
  ADD CONSTRAINT `fk_t_ressource_rsc_has_t_indisponibilite_ids_t_indisponibilit1` FOREIGN KEY (`ids_id`) REFERENCES `t_indisponibilite_ids` (`ids_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_t_ressource_rsc_has_t_indisponibilite_ids_t_ressource_rsc1` FOREIGN KEY (`rsc_id`) REFERENCES `t_ressource_rsc` (`rsc_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `t_messageinviter_mei`
--
ALTER TABLE `t_messageinviter_mei`
  ADD CONSTRAINT `fk_t_messageinviter_mei_t_compte_com2` FOREIGN KEY (`com_id`) REFERENCES `t_compte_com` (`com_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `t_participer_par`
--
ALTER TABLE `t_participer_par`
  ADD CONSTRAINT `fk_t_participer_par_t_compte_com1` FOREIGN KEY (`com_id`) REFERENCES `t_compte_com` (`com_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_t_resevation_res_has_t_reunion_reu_t_reunion_reu1` FOREIGN KEY (`reu_id`) REFERENCES `t_reunion_reu` (`reu_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `t_profil_pro`
--
ALTER TABLE `t_profil_pro`
  ADD CONSTRAINT `fk_t_profil_pro_t_compte_com1` FOREIGN KEY (`com_id`) REFERENCES `t_compte_com` (`com_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `t_reservation_res`
--
ALTER TABLE `t_reservation_res`
  ADD CONSTRAINT `fk_t_resevation_res_t_ressource_rsc1` FOREIGN KEY (`rsc_id`) REFERENCES `t_ressource_rsc` (`rsc_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `t_reserver_rsv`
--
ALTER TABLE `t_reserver_rsv`
  ADD CONSTRAINT `fk_t_compte_com_has_t_resevation_res_t_compte_com1` FOREIGN KEY (`com_id`) REFERENCES `t_compte_com` (`com_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_t_compte_com_has_t_resevation_res_t_resevation_res1` FOREIGN KEY (`res_id`) REFERENCES `t_reservation_res` (`res_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
