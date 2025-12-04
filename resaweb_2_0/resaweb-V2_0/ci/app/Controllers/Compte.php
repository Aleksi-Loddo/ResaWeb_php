<?php
namespace App\Controllers;
use App\Models\Db_model;
use CodeIgniter\Exceptions\PageNotFoundException;
class Compte extends BaseController
{
    public function __construct()
    {
        helper('form');
        $this->model = model(Db_model::class);
    }
    public function lister()
    {

        $data['titre'] = "Liste de tous les comptes";
        $data['logins'] = $this->model->get_all_compte();
        $data['num_compte'] = $this->model->get_num_compte_count();
        return view('templates/haut', $data)
            . view('affichage_comptes')
            . view('templates/bas');
    }

    // modifier la d´fonction pour l'espace admin seulement
    public function creer()
    {


        // L’utilisateur a validé le formulaire en cliquant sur le bouton
        if ($this->request->getMethod() == "POST") {
            if (
                !$this->validate(
                    [
                        'pseudo' => 'required|max_length[255]|min_length[2]',
                        'mdp' => 'required|max_length[255]|min_length[8]'
                    ],
                    [

                        // Configuration des messages d’erreurs
                        'pseudo' => [
                            'required' => 'Veuillez entrer un pseudo pour le compte !',
                            'min_length' => 'Le pseudo saisi est trop court !',
                            'max_length' => 'Le pseudo saisi est trop long !',
                        ],
                        'mdp' => [
                            'required' => 'Veuillez entrer un mot de passe !',
                            'min_length' => 'Le mot de passe saisi est trop court !',
                            'max_length' => 'Le pseudo saisi est trop long !',
                        ],
                    ]
                )
            ) {
                // La validation du formulaire a échoué, retour au formulaire !
                return view('templates/haut', ['titre' => 'Créer un compte'])
                    . view('compte/compte_creer')
                    . view('templates/bas');
            }
            // La validation du formulaire a réussi, traitement du formulaire
            $recuperation = $this->validator->getValidated();
            $this->model->set_compte($recuperation);
            $data['le_compte'] = $recuperation['pseudo'];
            $data['le_message'] = "Nouveau nombre de comptes : ";
            //Appel de la fonction créée dans le précédent tutoriel :
            $data['num_compte'] = $this->model->get_num_compte_count();
            return view('templates/haut', $data)
                . view('compte/compte_succes')
                . view('templates/bas');
        }
        // L’utilisateur veut afficher le formulaire pour créer un compte
        return view('templates/haut', ['titre' => 'Créer un compte'])
            . view('compte/compte_creer')
            . view('templates/bas');
    }

    public function connecter()
    {
        $model = model(Db_model::class);

        if ($this->request->getMethod() == "POST") {

            if (
                !$this->validate([
                    'pseudo' => 'required',
                    'mdp' => 'required'
                ])
            ) {
                return view('templates/haut', ['titre' => 'Se connecter'])
                    . view('connexion/compte_connecter')
                    . view('templates/bas');
            }

            // Récupération des valeurs
            $username = $this->request->getVar('pseudo');
            $password = $this->request->getVar('mdp');

            // Vérification identifiants
            $role = $model->connect_compte($username, $password);

            if ($role === false) {
                // --- MESSAGE D’ERREUR ---
                session()->setFlashdata('error', 'Identifiants erronés ou inexistants !');

                // Redirection vers le formulaire
                return redirect()->to('/compte/connecter');
            }

            // Connexion acceptée → créer la session
            $session = session();
            $session->set('user_id', $role['com_id']); //revenir dessus si sa fonctionne pas
            $session->set('user', $username);
            $session->set('role', $role['pro_role']);  // A ou M

            // Redirection selon rôle
            if ($role['pro_role'] == "A") {
                return redirect()->to('compte/dashboard-admin');
            } else {
                return redirect()->to('compte/dashboard-membre');
            }
        }

        // Affichage initial du formulaire
        return view('templates/haut', ['titre' => 'Se connecter'])
            . view('connexion/compte_connecter')
            . view('templates/bas');
    }

    public function dashboard_admin()
    {
        $session = session();
        if (!$session->has('user') || $session->get('role') !== "A") {
            return redirect()->to('/compte/connecter');
        }

        $pseudo = session()->get('user');

        $data['reservations_passees'] = $this->model->get_reservations_passees($pseudo);
        $data['reservations_a_venir'] = $this->model->get_reservations_a_venir($pseudo);
        $data['personne'] = $pseudo;

        return view('templates/haut_backoffice')
            . view('menu_administrateur', $data);
            
    }

    public function dashboard_membre()
    {
        $session = session();
        if (!$session->has('user') || $session->get('role') !== "M") {
            return redirect()->to('/compte/connecter');
        }

        $pseudo = session()->get('user');

        $data['reservations_passees'] = $this->model->get_reservations_passees($pseudo);
        $data['reservations_a_venir'] = $this->model->get_reservations_a_venir($pseudo);
        $data['personne'] = $pseudo;

        return view('templates/haut_backoffice_membre')
            . view('menu_membre', $data);
    }

    public function accueil()
    {
        $session = session();

        if (!$session->has('user')) {
            return redirect()->to('/compte/connecter');
        }

        // redirection selon rôle
        if ($session->get('role') == "A") {
            return redirect()->to('compte/dashboard-admin');
        } else {
            return redirect()->to('compte/dashboard-membre');
        }
    }




    public function afficher_profil()
    {
        $session = session();

        if ($session->has('user')) {

            $profil = $this->model->get_profil($session->get('user'));

            $data['profil'] = $profil;
            $data['personne'] = $session->get('user');

            return view('templates/haut_profil')
                . view('connexion/compte_profil', $data);
        } else {

            $session = session();

            return view('templates/haut')
                . view('connexion/compte_connecter')
                . view('templates/bas');
        }
    }



    public function get_reservations_a_venir()
    {
        $sql = "SELECT * FROM t_reservation_res WHERE res_date > CURDATE() ORDER BY res_date ASC";
        return $this->db->query($sql)->getResult();
    }

    public function get_reservations_passees()
    {
        $sql = "SELECT * FROM t_reservation_res WHERE res_date < CURDATE() ORDER BY res_date DESC";
        return $this->db->query($sql)->getResult();
    }

    public function deconnecter()
    {
        $session = session();
        $session->destroy();
        return view('templates/haut', ['titre' => 'Se connecter'])
            . view('connexion/compte_connecter')
            . view('templates/bas');

    }

    // mise a jour de information dans profil

    public function modifier_profil()
    {


        $session = session();

        if (!$session->has('user')) {
            return redirect()->to('/compte/connecter');
        }


        // On autorise seulement membres et admins
        $role = $session->get('role');
        if ($role !== "M" && $role !== "A") {
            return redirect()->to('/compte/connecter');
        }
        $pseudo = $session->get('user');
        $profil = $this->model->get_profil($pseudo);

        $data['profil'] = $profil;
        $data['personne'] = $pseudo;


        // Vue différente selon A ou M (si tu veux garder les mêmes menus)
        if ($role == "A") {
            return view('templates/haut_backoffice')
                . view('compte/compte_modifier', $data);
        } else {
            return view('templates/haut_backoffice_membre')
                . view('compte/compte_modifier', $data);

        }

    }

    public function update_profil()
    {
        $session = session();

        // Vérifier que l'utilisateur est connecté
        if (!$session->has('user')) {
            return redirect()->to('/compte/connecter');
        }

        $pseudo = $session->get('user');
        $role = $session->get('role'); // M ou A

        if ($role !== "M" && $role !== "A") {
            return redirect()->to('/compte/connecter');
        }

        // Vérifier que les champs obligatoires ne sont pas vides
        if (
            empty($_POST['pro_nom']) ||
            empty($_POST['pro_prenom']) ||
            empty($_POST['pro_datedenaissance']) ||
            empty($_POST['pro_mail']) ||
            empty($_POST['pro_adress']) ||
            empty($_POST['pro_telmob'])
        ) {
            session()->setFlashdata('error', "Champs de saisie vides !");
            return redirect()->to('compte/modifier_profil');
        }

        // Gestion du mot de passe (User Stories 8 et 21)
        $pass = $this->request->getPost('password');
        $confirm = $this->request->getPost('confirm');

        if (!empty($pass) || !empty($confirm)) {
            // Si l'un des deux est vide ou qu'ils sont différents → erreur
            if (empty($pass) || empty($confirm) || $pass !== $confirm) {
                session()->setFlashdata('error', "Confirmation du mot de passe erronée, veuillez réessayer !");
                return redirect()->to('compte/modifier_profil');
            }

            // Mise à jour du mot de passe en clair,
            // le trigger MySQL fera le hash
            $this->model->update_password($pseudo, $pass);
        }

        // Données du profil à mettre à jour
        $data = [
            'pro_nom' => $this->request->getPost('pro_nom'),
            'pro_prenom' => $this->request->getPost('pro_prenom'),
            'pro_datedenaissance' => $this->request->getPost('pro_datedenaissance'),
            'pro_mail' => $this->request->getPost('pro_mail'),
            'pro_adress' => $this->request->getPost('pro_adress'),
            'pro_telmob' => $this->request->getPost('pro_telmob'),
            'pro_telfix' => $this->request->getPost('pro_telfix'),
        ];

        // Mise à jour du profil
        $this->model->update_profil($pseudo, $data);

        session()->setFlashdata('success', "Profil mis à jour !");
        return redirect()->to('compte/afficher_profil');
    }

}















