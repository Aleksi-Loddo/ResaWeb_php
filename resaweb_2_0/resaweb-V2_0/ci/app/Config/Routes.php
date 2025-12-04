<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */
//$routes->get('/', 'Home::index');

use App\Controllers\Accueil;
use App\Controllers\Back_office;
use App\Controllers\Compte;
use App\Controllers\Actualite;
use App\Controllers\Messagevisiteur;
use App\Controllers\Gestion;






//$routes->get('accueil/afficher/(:segment)', [Accueil::class, 'afficher']);

$routes->get('/', [Accueil::class, 'afficher']);

//$routes->get('accueil/afficher', [Accueil::class, 'afficher']);

$routes->get('Back_office', [Back_office::class, 'afficher_priver']);
$routes->get('compte/lister', [Compte::class, 'lister']);
$routes->get('actualite/afficher', [Actualite::class, 'afficher']);
$routes->get('actualite/afficher/(:segment)', [Actualite::class, 'afficher']);
$routes->get('messageinvite/(:any)', 'Messagevisiteur::getter_message_visiteur/$1');
$routes->get('compte/creer', [Compte::class, 'creer']);
$routes->post('compte/creer', [Compte::class, 'creer']);
$routes->get('MessageInvitee/saisirCode', 'Messagevisiteur::saisirCode');
$routes->post('MessageInvitee/verifierCode', 'Messagevisiteur::verifierCode');
$routes->get('contact', 'Messagevisiteur::contact');
$routes->post('contact/envoyer', 'Messagevisiteur::envoyerMessage');
$routes->get('compte/connecter', [Compte::class, 'connecter']);
$routes->post('compte/connecter', [Compte::class, 'connecter']);
$routes->get('compte/afficher_profil', 'Compte::afficher_profil');
$routes->get('compte/deconnecter', 'Compte::deconnecter');
$routes->get('compte/dashboard-admin', 'Compte::dashboard_admin');
$routes->get('compte/dashboard-membre', 'Compte::dashboard_membre');
$routes->get('compte/accueil', 'Compte::accueil');
$routes->get('compte/modifier_profil', 'Compte::modifier_profil');
$routes->post('compte/update_profil', 'Compte::update_profil');
$routes->get('liste_membres', 'Gestion_association::get_membre_liste');
$routes->get('admin_gestion_membres', 'Gestion_association::get_all_membre_admin');
$routes->get('admin_list_message', 'Gestion_association::message_visiteur');
$routes->get('reponse_message/(:num)', 'Gestion_association::repondre_message/$1');
$routes->post('gestion_association/envoyer_reponse/(:num)', 'Gestion_association::envoyer_reponse/$1');
$routes->get('crenaux', 'Gestion_association::reservations');
$routes->post('reservations_jour', 'Gestion_association::reservations_jour');
$routes->post('reserver_crenaux', 'Gestion_association::reserver_crenaux');
// Voir le formulaire
$routes->get('ressource_ajouter', 'Gestion_association::ressource_ajouter');

// Traitement du formulaire
$routes->post('ressource_ajouter', 'Gestion_association::ressource_insert');

// Suppression
$routes->get('ressource_supprimer/(:num)', 'Gestion_association::ressource_supprimer/$1');

// Liste
$routes->get('ressources', 'Gestion_association::ressources');

$routes->get('admin_gestion_membres', 'Gestion_association::affichage_liste_membres');

$routes->post('admin_gestion_membres/ajouterInvite', 'Gestion_association::ajouterInvite');



/*
https://obiwan.univ-brest.fr/~e22501948/
https://obiwan.univ-brest.fr/~e22501948/index.php/Back_office
https://obiwan.univ-brest.fr/~e22501948/index.php/compte/lister
https://obiwan.univ-brest.fr/~e22501948/index.php/actualite

---    lien  pour code de message invite manuel
https://obiwan.univ-brest.fr/~e22501948/index.php/messageinvite/9F4L7AXYOEYZGCHNYG0D   code correct
https://obiwan.univ-brest.fr/~e22501948/index.php/messageinvite/                       sans code invite !!
https://obiwan.univ-brest.fr/~e22501948/index.php/messageinvite/12345678912345678910   code incorrect  !!
----
---- lien code de message invite a travers interface seulement
https://obiwan.univ-brest.fr/~e22501948/index.php/MessageInvitee/saisirCode
https://obiwan.univ-brest.fr/~e22501948/index.php/MessageInvitee/verifierCode  
----
---- lien pour concecter un compte
https://obiwan.univ-brest.fr/~e22501948/index.php/compte/connecter     accés au backoffice back office
https://obiwan.univ-brest.fr/~e22501948/index.php/compte/creer

----backoffice

https://obiwan.univ-brest.fr/~e22501948/index.php/affichage_liste_membres


*/



