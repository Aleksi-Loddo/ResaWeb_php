<?php
namespace App\Controllers;
use App\Models\Db_model;
use CodeIgniter\Exceptions\PageNotFoundException;
class Messagevisiteur extends BaseController
{
    public function __construct()
    {
        helper(['form']);
        $this->model = model(Db_model::class);


    }


    public function getter_message_visiteur($segment)
    {
        //dd($segment); // STOP ici
        //$segment = trim($segment);

        // Si aucun code dans l'URL
        if (empty($segment)) {
            return redirect()->to('/MessageInvitee/saisirCode');
        }

        // Mauvaise longueur
        if (strlen($segment) !== 20) {
            return view('templates/haut')
                . view('affichage_saisircode', ['validation' => "Le code doit contenir exactement 20 caractères !"])
                . view('templates/bas');

        }

        $message = $this->model->get_message_visiteur($segment);

        if (!$message) {
            return view('templates/haut')
                . view('affichage_saisircode', ['validation' => "Aucune demande trouvée correspondant au code saisi !"])
                . view('templates/bas');
        }

        // Succès
        $pseudo = $this->model->get_compte_pseudo($message->com_id);

        return view('templates/haut')
            . view('affichage_messagevisiteur', ['message' => $message, 'pseudo' => $pseudo])
            . view('templates/bas');
    }


    public function saisirCode()
    {
        return view('templates/haut')
            . view('affichage_saisircode')
            . view('templates/bas');
    }

    public function verifierCode()
    {
        $code = trim($this->request->getPost('code_suivi'));

        // Formulaire vide
        if (empty($code)) {
            return view('templates/haut')
                . view('affichage_saisircode', ['validation' => "Veuillez remplir le formulaire !"])
                . view('templates/bas');
        }

        // Mauvaise longueur
        if (strlen($code) !== 20) {
            return view('templates/haut')
                . view('affichage_saisircode', ['validation' => "Le code doit contenir exactement 20 caractères !"])
                . view('templates/bas');
        }

        // Recherche du message
        $message = $this->model->get_message_by_code($code);

        if (!$message) {
            return view('templates/haut')
                . view('affichage_saisircode', ['validation' => "Aucune demande trouvée correspondant au code saisi !"])
                . view('templates/bas');
        }

        // Succès

        if (!empty($message['com_id'])) {
            $pseudo = $this->model->get_compte_pseudo($message['com_id']);
        } else {
            $pseudo = null;
        }

        return view('templates/haut')
            . view('affichage_messagevisiteur', ['message' => $message, 'pseudo' => $pseudo])
            . view('templates/bas');
    }


    public function contact()
    {
        return view('templates/haut')
            . view('contact/affichage_contact')
            . view('templates/bas');
    }

    public function envoyerMessage()
    {
        if ($this->request->getMethod() == "POST") {

            if (
                !$this->validate(
                    [
                        'email' => 'required|valid_email|max_length[255]',
                        'titre' => 'required|max_length[100]|',
                        'message' => 'required|max_length[600]'
                    ],
                    [
                        'email' => [
                            'required' => 'Veuillez entrer une adresse email !',
                            'valid_email' => 'L’email saisi n’est pas valide !',
                            'max_length' => 'L’email saisi est trop long !',
                        ],
                        'titre' => [
                            'required' => 'Veuillez entrer un titre !',
                            'max_length' => 'Le titre est trop long !',
                        ],
                        'message' => [
                            'required' => 'Veuillez entrer un message !',
                            'max_length' => 'le messsage saisi est trop long !',
                        ],
                    ]
                )
            ) {
                return view('templates/haut')
                    . view('contact/affichage_contact', [
                        'validation' => $this->validator
                    ])
                    . view('templates/bas');
            }

            // données validées
            $valid = $this->validator->getValidated();

            // préparation data
            $data = [
                'mei_email' => $valid['email'],
                'mei_titre' => $valid['titre'],
                'mei_contenu' => $valid['message'],
            ];


            // insertion + récupération du code
            $code = $this->model->insertion_message($data);

            return view('templates/haut')
                . view('contact/affichage_confirmation_contact', ['code' => $code])
                . view('templates/bas');
        }

        return view('templates/haut')
            . view('contact/affichage_contact')
            . view('templates/bas');
    }


}


