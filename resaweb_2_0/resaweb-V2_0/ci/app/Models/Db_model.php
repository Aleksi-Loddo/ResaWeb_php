<?php
namespace App\Models;
use CodeIgniter\Model;

class Db_model extends Model
{
  protected $db;

  /* ============================================================
     🔌 CONNEXION BDD
  ============================================================ */
  public function __construct()
  {
    $this->db = db_connect();
  }


  /* ============================================================
     👥 COMPTES (CRUD + Connexion)
  ============================================================ */
  // Récupère tous les pseudos des comptes utilisateurs
  public function get_all_compte()
  {
    return $this->db->query("SELECT com_pseudo FROM t_compte_com")->getResultArray();
  }
  // Récupère un compte utilisateur par son ID
  public function get_compte_pseudo($id_com)
  {
    return $this->db->query(
      "SELECT * FROM t_compte_com WHERE com_id = $id_com"
    )->getRow();
  }
  // Insère un nouveau compte utilisateur
  public function set_compte($saisie)
  {
    // Hash manuel (un trigger pourrait remplacer ceci)
    $login = $saisie['pseudo'];
    $salt = 'celaestmonsalt123';
    $mdp = $saisie['mdp'];

    $sql = "INSERT INTO t_compte_com (com_pseudo, com_passwordhash, com_etat)
                VALUES ('$login', SHA2(CONCAT('$salt', '$mdp'), 256), 1)";
    return $this->db->query($sql);
  }
  // Vérifie les informations de connexion d'un utilisateur
  public function connect_compte($u, $plainPassword)
  {
    $sql = "SELECT t_compte_com.com_id, com_pseudo, pro_role
                FROM t_compte_com
                JOIN t_profil_pro ON t_profil_pro.com_id = t_compte_com.com_id
                WHERE com_pseudo = ?
                  AND com_passwordhash = SHA2(CONCAT('celaestmonsalt123', ?), 256)";

    $res = $this->db->query($sql, [$u, $plainPassword]);
    return $res->getNumRows() == 1 ? $res->getRowArray() : false;
  }
  // Vérifie si un pseudo existe déjà
  public function pseudo_exists($pseudo)
  {
    return $this->db
      ->query("SELECT com_id FROM t_compte_com WHERE com_pseudo = ?", [$pseudo])
      ->getRow() !== null;
  }
  // Met à jour le mot de passe d'un utilisateur donné
  public function update_password($pseudo, $plainPassword)
  {
    // Le trigger fait le hash
    return $this->db->query(
      "UPDATE t_compte_com SET com_passwordhash = ? WHERE com_pseudo = ?",
      [$plainPassword, $pseudo]
    );
  }
  // Récupère l'ID d'un compte via son pseudo
  public function get_id_from_pseudo($pseudo)
  {
    $row = $this->db
      ->query("SELECT com_id FROM t_compte_com WHERE com_pseudo = ?", [$pseudo])
      ->getRow();

    return $row->com_id ?? null;
  }
  // Récupère le nombre total de comptes
  public function get_num_compte_count()
  {
    return $this->db
      ->query("SELECT COUNT(*) AS total FROM t_compte_com")
      ->getRow();
  }


  /* ============================================================
     📰 ACTUALITÉS
  ============================================================ */
  // Récupère une actualité par son numéro
  public function get_actualite($numero)
  {
    return $this->db
      ->query("SELECT * FROM t_actualite_act WHERE act_id = $numero")
      ->getRow();
  }
  // Récupère toutes les actualités actives avec le pseudo de l'auteur
  public function get_all_actualite()
  {
    $sql = "
            SELECT a.*, c.com_pseudo AS auteur
            FROM t_actualite_act a
            JOIN t_compte_com c ON c.com_id = a.com_id
            WHERE a.act_etat = 'A'
            ORDER BY a.act_datepublication DESC";

    return $this->db->query($sql)->getResultArray();
  }


  /* ============================================================
     🧑‍🤝‍🧑 PROFILS
  ============================================================ */
  // Récupère le profil d'un utilisateur donné via son pseudo
  public function get_profil($pseudo)
  {
    $sql = "
            SELECT *
            FROM t_profil_pro
            JOIN t_compte_com ON t_profil_pro.com_id = t_compte_com.com_id
            WHERE t_compte_com.com_pseudo = ?";

    return $this->db->query($sql, [$pseudo])->getRow();
  }
  // Récupère la liste complète des membres
  public function get_membre_list()
  {
    return $this->db
      ->query("SELECT * FROM t_profil_pro")
      ->getResultArray();
  }
  // Récupère les membres via la vue SQL v_membre_mem
  public function get_membres_via_vue()
  {
    return $this->db
      ->query("SELECT * FROM v_membre_mem ORDER BY com_pseudo ASC")
      ->getResultArray();
  }
  // Met à jour le profil d'un utilisateur donné
  public function update_profil($pseudo, $data)
  {
    $row = $this->db
      ->query("SELECT com_id FROM t_compte_com WHERE com_pseudo = ?", [$pseudo])
      ->getRow();

    if (!$row)
      return false;

    $sql = "
            UPDATE t_profil_pro SET
                pro_nom = ?, pro_prenom = ?, pro_datedenaissance = ?,
                pro_mail = ?, pro_adress = ?, pro_telmob = ?, pro_telfix = ?
            WHERE com_id = ?";

    return $this->db->query($sql, [
      $data['pro_nom'],
      $data['pro_prenom'],
      $data['pro_datedenaissance'],
      $data['pro_mail'],
      $data['pro_adress'],
      $data['pro_telmob'],
      $data['pro_telfix'],
      $row->com_id
    ]);
  }


  /* ============================================================
     ✉️ MESSAGES VISITEURS
  ============================================================ */
  // Insère un nouveau message visiteur et retourne son code unique
  public function insertion_message($data)
  {
    $code = substr(md5(random_bytes(10)), 0, 20);

    $email = $this->db->escape($data['mei_email']);
    $titre = $this->db->escape($data['mei_titre']);
    $contenu = $this->db->escape($data['mei_contenu']);
    $codeSQL = $this->db->escape($code);

    $sql = "
            INSERT INTO t_messageinviter_mei
            (mei_email, mei_titre, mei_contenu, mei_datecreation, mei_code)
            VALUES ($email, $titre, $contenu, CURDATE(), $codeSQL)";

    $this->db->query($sql);
    return $code;
  }
  // Récupère un message visiteur par son code unique
  public function get_message_by_code($code)
  {
    return $this->db
      ->query("SELECT * FROM t_messageinviter_mei WHERE mei_code = ?", [$code])
      ->getRowArray();
  }
  // Récupère un message visiteur par son ID
  public function get_message_visiteur($id)
  {
    return $this->db
      ->query("SELECT * FROM t_messageinviter_mei WHERE mei_id = ?", [$id])
      ->getRowArray();
  }
  // Récupère tous les messages visiteurs, les non-répondus en premier
  public function get_all_message_visiteur()
  {
    $sql = "
            SELECT *
            FROM t_messageinviter_mei
            ORDER BY (mei_reponse IS NOT NULL), mei_datecreation DESC";

    return $this->db->query($sql)->getResultArray();
  }
  // Met à jour la réponse à un message visiteur
  public function update_message_reponse($id, $reponse, $com_id)
  {
    return $this->db->query(
      "UPDATE t_messageinviter_mei SET mei_reponse = ?, com_id = ? WHERE mei_id = ?",
      [$reponse, $com_id, $id]
    );
  }


  /* ============================================================
     📅 RÉSERVATIONS
  ============================================================ */
  // Récupère les réservations à venir pour un utilisateur donné
  public function get_reservations_a_venir($pseudo)
  {
    $sql = "
        SELECT 
            r.res_id,
            r.res_lieu,
            r.res_datereservation,
            r.res_heuredebut,
            NULL AS res_heurefin,
         
          DATE_ADD(r.res_heuredebut, INTERVAL 3 HOUR) AS res_heurefin,

            cResp.com_pseudo AS responsable,

            GROUP_CONCAT(DISTINCT u.com_pseudo
                         ORDER BY u.com_pseudo SEPARATOR ', ') AS participants

        FROM t_reservation_res r

        LEFT JOIN t_reserver_rsv rrUser
               ON rrUser.res_id = r.res_id
        LEFT JOIN t_compte_com cUser
               ON cUser.com_id = rrUser.com_id
              AND cUser.com_pseudo = ?

        LEFT JOIN t_reserver_rsv rrResp
               ON rrResp.res_id = r.res_id
              AND rrResp.rsv_role = 'A'
        LEFT JOIN t_compte_com cResp
               ON cResp.com_id = rrResp.com_id

        LEFT JOIN t_reserver_rsv rv  ON rv.res_id = r.res_id
        LEFT JOIN t_compte_com  u    ON u.com_id  = rv.com_id

        WHERE 
            CAST(r.res_heuredebut AS DATETIME) >= NOW()
            AND (
                cUser.com_pseudo IS NOT NULL
                OR cResp.com_pseudo = ?
            )

        GROUP BY r.res_id
        ORDER BY r.res_heuredebut ASC;
    ";

    return $this->db->query($sql, [$pseudo, $pseudo])->getResultArray();
  }

  // Récupère les réservations passées pour un utilisateur donné
  public function get_reservations_passees($pseudo)
  {
    $sql = "
        SELECT 
            r.res_id,
            r.res_lieu,
            r.res_datereservation,
            r.res_heuredebut,
            r.res_bilanreservation,

            DATE_ADD(r.res_heuredebut, INTERVAL 3 HOUR) AS res_heurefin,

            resp.com_pseudo AS responsable,

            GROUP_CONCAT(DISTINCT u.com_pseudo
                         ORDER BY u.com_pseudo SEPARATOR ', ') AS participants

        FROM t_reservation_res r

        JOIN t_reserver_rsv rrUser
               ON rrUser.res_id = r.res_id
        JOIN t_compte_com cUser
               ON cUser.com_id = rrUser.com_id
              AND cUser.com_pseudo = ?

        LEFT JOIN t_reserver_rsv rv  ON rv.res_id = r.res_id
        LEFT JOIN t_compte_com  u    ON u.com_id  = rv.com_id

        LEFT JOIN t_reserver_rsv rv_resp
               ON rv_resp.res_id   = r.res_id
              AND rv_resp.rsv_role = 'A'
        LEFT JOIN t_compte_com resp
               ON resp.com_id      = rv_resp.com_id

        WHERE CAST(r.res_heuredebut AS DATETIME) < NOW()

        GROUP BY r.res_id
        ORDER BY r.res_heuredebut DESC;
    ";

    return $this->db->query($sql, [$pseudo])->getResultArray();
  }

  // Récupère les réservations pour une date donnée
  public function get_reservations_by_date($date)
  {
    $sql = "
            SELECT r.res_id, r.rsc_id, rc.rsc_salleid AS salle,
                   r.res_datereservation, r.res_heuredebut, r.res_bilanreservation
            FROM t_reservation_res r
            JOIN t_ressource_rsc rc ON rc.rsc_id = r.rsc_id
            WHERE DATE(r.res_datereservation) = ?
            ORDER BY rc.rsc_salleid, r.res_heuredebut";

    return $this->db->query($sql, [$date])->getResultArray();
  }
  // Récupère les indisponibilités pour une date donnée
  public function getIndisposByDate($date)
  {
    $sql = "
            SELECT ind.rsc_id, rc.rsc_salleid AS salle, ids.ids_datedebut,
                   ids.ids_datefin, ids.ids_etat, rai.rai_raison AS motif
            FROM t_indisponible_ind ind
            JOIN t_ressource_rsc rc ON rc.rsc_id = ind.rsc_id
            JOIN t_indisponibilite_ids ids ON ids.ids_id = ind.ids_id
            JOIN t_raison_rai rai ON rai.rai_id = ids.rai_id
            WHERE DATE(ids.ids_datedebut) <= ?
              AND DATE(ids.ids_datefin) >= ?
            ORDER BY rc.rsc_salleid, ids.ids_datedebut";

    return $this->db->query($sql, [$date, $date])->getResultArray();
  }
  // Récupère les réservations via la procédure stockée p_reservations_by_date
  public function get_reservations_via_procedure($date)
  {
    return $this->db
      ->query("CALL p_reservations_by_date(?)", [$date])
      ->getResultArray();
  }


  /* ============================================================
     🏢 RESSOURCES (Salles)
  ============================================================ */

  // Récupère toutes les ressources avec le nom de la salle via la fonction SQL f_salle_label
  public function get_all_resources()
  {
    $sql = "
            SELECT rsc_id, rsc_salleid,
                   f_salle_label(rsc_salleid) AS salle_nom,
                   rsc_jaugemin, rsc_jaugemax, rsc_photo
            FROM t_ressource_rsc
            ORDER BY rsc_salleid";

    return $this->db->query($sql)->getResultArray();
  }
  // Insère une nouvelle ressource
  public function insert_resource($data)
  {
    $sql = "
            INSERT INTO t_ressource_rsc (rsc_salleid, rsc_jaugemin, rsc_jaugemax, rsc_photo)
            VALUES (?, ?, ?, ?)";

    return $this->db->query($sql, [
      $data['salle'],
      $data['jmin'],
      $data['jmax'],
      $data['photo'] ?? null
    ]);
  }

  public function delete_resource($id)
  {
    // suppression participations
    $this->db->query("
            DELETE FROM t_reserver_rsv
            WHERE res_id IN (SELECT res_id FROM t_reservation_res WHERE rsc_id = ?)",
      [$id]
    );

    // suppression réservations
    $this->db->query("DELETE FROM t_reservation_res WHERE rsc_id = ?", [$id]);

    // suppression indisponibilités
    $this->db->query("DELETE FROM t_indisponible_ind WHERE rsc_id = ?", [$id]);

    // suppression ressource
    return $this->db->query("DELETE FROM t_ressource_rsc WHERE rsc_id = ?", [$id]);
  }
  // Vérifie si une salle existe déjà
  public function salle_exists($salle)
  {
    return $this->db
      ->query("SELECT rsc_id FROM t_ressource_rsc WHERE rsc_salleid = ?", [$salle])
      ->getRow() !== null;
  }
}
