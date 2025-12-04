<?php
namespace App\Controllers;
use App\Models\Db_model;
use CodeIgniter\Exceptions\PageNotFoundException;
class Accueil extends BaseController
{
    public function afficher($donnee = null)
    {
         $model = model(Db_model::class);
         
        $data['parametre_url'] = ($donnee);
        $data['actu'] = $model->get_all_actualite();
        return view('templates/haut', $data)
            . view('affichage_accueil')
            . view('templates/bas');
    }
}
?>