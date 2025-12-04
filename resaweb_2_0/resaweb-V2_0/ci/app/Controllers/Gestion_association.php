<?php
namespace App\Controllers;
use App\Models\Db_model;
use CodeIgniter\Exceptions\PageNotFoundException;
class Gestion_association extends BaseController
{
    public function __construct()
    {
        helper('form');
        $this->model = model(Db_model::class);
    }

    public function get_membre_liste()
    {
        $session = session();

        if (!$session->has('user')) {
            return redirect()->to('/compte/connecter');
        } else {

            $membre_list = $this->model->get_membre_list();
            $data['membre_list'] = $membre_list;

            return view('templates/haut_profil')
                . view('gestion_membre/affichage_listmembre', $data);
        }
    }

    public function get_all_membre_admin()
    {

        $session = session();
        if (!$session->has('user') || $session->get('role') !== "A") {
            return redirect()->to('/compte/connecter');
        }
        $membre_list_admin = $this->model->get_membres_via_vue();
        $info['membre_list_admin'] = $membre_list_admin;

        return view('templates/haut_profil')
            . view('gestion_membre/affichage_listmembre_admin', $info);
    }

    public function message_visiteur()
    {

        $session = session();
        if (!$session->has('user') || $session->get('role') !== "A") {
            return redirect()->to('/compte/connecter');
        }
        //$message_visiteur['message_visiteur'] = $this->model->get_all_message_visiteur();
        // $data['message_visiteur'] = $message_visiteur;

        $data['message_visiteur'] = $this->model->get_all_message_visiteur();


        return view('templates/haut_profil')
            . view('gestion_message/affichage_messagelist', $data);
    }

    public function repondre_message($message_id)
    {

        $session = session();

        // 🔒 Sécurité : accès admin uniquement
        if (!$session->has('user') || $session->get('role') !== "A") {
            return redirect()->to('/compte/connecter');
        }

        $message = $this->model->get_message_visiteur($message_id);
        if (!$message) {
            //error meessage
        }

        if (!$message) {
            session()->setFlashdata('error', 'Message introuvable !');
            return redirect()->to('/admin_list_message');
        }
        $data['message'] = $message;

        return view('templates/haut_profil')
            . view('gestion_message/form_reponse', $data);

    }


    public function envoyer_reponse($id)
    {
        $session = session();

        if (!$session->has('user') || $session->get('role') !== "A") {
            return redirect()->to('/compte/connecter');
        }

        $reponse = $this->request->getPost('reponse');

        if (empty($reponse)) {
            session()->setFlashdata('error', "Veuillez remplir le formulaire !");
            return redirect()->back();
        }

        // récupérer com_id de l’admin
        $pseudo = $session->get('user');
        $com_id = $this->model->get_id_from_pseudo($pseudo);

        if (!$com_id) {
            session()->setFlashdata('error', "Erreur interne : utilisateur introuvable !");
            return redirect()->back();
        }

        // faire l’update correct
        $this->model->update_message_reponse($id, $reponse, $com_id);

        session()->setFlashdata('success', "Réponse envoyée !");
        return redirect()->to('/admin_list_message');
    }

    public function reservations()
    {
        $session = session();
        if (!$session->has('user'))
            return redirect()->to('/compte/connecter');

        return view('templates/haut_profil')
            . view('gestion_creneaux/choix_date');
    }


   public function reservations_jour()
{
    $session = session();
    if (!$session->has('user')) {
        return redirect()->to('/compte/connecter');
    }

    // Récupération date du formulaire
    $date = $this->request->getPost('date');
    if (!$date) {
        session()->setFlashdata('error', "Veuillez choisir une date.");
        return redirect()->to('reservations');
    }

    // Remplissage du tableau $data pour la vue
    $data['date'] = $date;
    $data['reservations'] = $this->model->get_reservations_via_procedure($date);

    // ⚠ Ajout indispensable pour que la vue fonctionne comme reservations_jour()
    $data['indispos'] = $this->model->getIndisposByDate($date);

    return view('templates/haut_profil')
         . view('gestion_creneaux/liste_jour', $data);
}
    public function ressources()
    {
        $session = session();

        // Accès réservé admin
        if (!$session->has('user') || $session->get('role') !== "A") {
            return redirect()->to('/compte/connecter');
        }

        $data['ressources'] = $this->model->get_all_resources();

        return view('templates/haut_profil')
            . view('gestion_ressources/liste_ressources', $data);
    }

    public function ressource_ajouter()
    {
        $session = session();

        if (!$session->has('user') || $session->get('role') !== "A") {
            return redirect()->to('/compte/connecter');
        }

        return view('templates/haut_profil')
            . view('gestion_ressources/ajouter_ressource');
    }
    public function ressource_insert()
    {
        $session = session();

        if (!$session->has('user') || $session->get('role') !== "A") {
            return redirect()->to('/compte/connecter');
        }

        // Validation simple
        $salle = $this->request->getPost('salle');
        $min = $this->request->getPost('jmin');
        $max = $this->request->getPost('jmax');

        if (empty($salle) || empty($min) || empty($max)) {
            session()->setFlashdata('error', 'Veuillez remplir tous les champs du formulaire.');
            return redirect()->back()->withInput();
        }
        //  Pas de négatifs
        if ($salle < 0 || $min < 0 || $max < 0) {
            session()->setFlashdata('error', 'Les valeurs négatives ne sont pas autorisées.');
            return redirect()->back()->withInput();
        }

        // min <= max
        if ($max < $min) {
            session()->setFlashdata('error', 'La jauge maximum doit être supérieure à la jauge minimum.');
            return redirect()->back()->withInput();
        }

        if ($min < 2 || $max > 6) {
            session()->setFlashdata('error', 'La jauge doit être comprise entre 2 et 6 personnes.');
            return redirect()->back()->withInput();
        }
        if ($min < 2 || $max > 6) {
            session()->setFlashdata('error', 'La jauge doit être comprise entre 2 et 6 personnes.');
            return redirect()->back()->withInput();
        }
        //  Salle déjà existante ?
        if ($this->model->salle_exists($salle)) {
            session()->setFlashdata('error', "La salle $salle existe déjà !");
            return redirect()->back()->withInput();
        }


        // Insertion
        $this->model->insert_resource([
            'salle' => $salle,
            'jmin' => $min,
            'jmax' => $max,
            'photo' => 'salle_default.jpg'
        ]);

        session()->setFlashdata('success', 'Ressource ajoutée !');
        return redirect()->to('/ressources');
    }
    public function ressource_supprimer($id)
    {
        $session = session();

        if (!$session->has('user') || $session->get('role') !== "A") {
            return redirect()->to('/compte/connecter');
        }

        $this->model->delete_resource($id);

        session()->setFlashdata('success', 'Ressource supprimée !');
        return redirect()->to('/ressources');
    }

    public function ajouterInvite()
    {
        $session = session();

        // Vérification admin
        if (!$session->has('user') || $session->get('role') !== "A") {
            return redirect()->to('/compte/connecter');
        }

        // Récupération du formulaire
        $pseudo = $this->request->getPost('pseudo');
        $motdepasse = $this->request->getPost('motdepasse');

        // Validation simple
        if (empty($pseudo) || empty($motdepasse)) {
            session()->setFlashdata('error', 'Veuillez remplir tous les champs.');
            return redirect()->back()->withInput();
        }

        // Vérifier si le pseudo existe déjà
        if ($this->model->pseudo_exists($pseudo)) {
            session()->setFlashdata('error', 'Ce compte existe déjà !');
            return redirect()->back()->withInput();
        }

        // Insertion du compte invité
        $data = [
            'pseudo' => $pseudo,
            'mdp' => $motdepasse
        ];

        $this->model->set_compte($data);

        session()->setFlashdata('success', 'Compte invité créé avec succès !');
        return redirect()->to('/admin_gestion_membres');
    }
}