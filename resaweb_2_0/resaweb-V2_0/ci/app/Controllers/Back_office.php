<?php
namespace App\Controllers;
use App\Models\Db_model;
use CodeIgniter\Exceptions\PageNotFoundException;
class back_office extends BaseController
{
    public function afficher_priver()
    {
       
        return view('templates/haut_backoffice')
            . view('affichage_backoffice');
    }
}
?>