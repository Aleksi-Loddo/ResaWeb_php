-Information

This project is a course exercise that I made in 2025 during my Erasmus exchange in france at UBO during the first semester

it was a guided work with many tutoriels during the lessons

-important to note

the link to the webiste only works on the intranet of the UBO




**Bellow is the  Readme file that was submited for evaluation


# 📄 README — Projet Web ResaWeb

**Auteur** : Aleksi Loddo  
**Date** : 2025  
**Application** : ResaWeb — Plateforme de gestion associative  

**Template Bootstrap utilisé** :  
- **Front office** : https://themefisher.com/products/agen-bootstrap  
- **Back office** : https://adminkit.lemonsqueezy.com/checkout  

**Version actuelle** : V2.1

## 📌 Présentation générale de l'application

ResaWeb est une application Web destinée aux associations afin de faciliter :

- La gestion des membres et de leurs profils
- La gestion des ressources (salles réservables)
- La réservation de créneaux
- La consultation centralisée des activités
- Une messagerie simple entre visiteurs et administrateurs

**Technologies utilisées** :

- CodeIgniter 4 (PHP)
- MySQL / MariaDB
- Apache 2.4
- Objets SQL : triggers, vues, procédures, fonctions

## 🌐 URL de la version en ligne

**👉 Version de production** :  
https://obiwan.univ-brest.fr/~e22501948/

## 👥 Comptes créés pour tester l'application

### 👑 Administrateurs

| Identifiant | Mot de passe |
|-------------|--------------|
| pascal.emile | pascale2025! |
| girard.juliette | girjul2025! |
| riviere.patrick | riviere123 |
| breton.eleonore | bretele2026! |
| renard.dominique | rendom456! |

### 👤 Membres

| Identifiant | Mot de passe |
|-------------|--------------|
| gros.alain | Alagro2024! |
| gonzalez.denis | gonznis2027! |
| mercier.henri | henmerci2025! |
| caron.clemence | clemcar2023! |
| leger.maurice | legere2025! |
| toussaint.lucie | tousslu2027! |

## 🏷️ Version en ligne (V2.1)

- Interface publique complète
- Gestion des ressources opérationnelle
- Réservations consultables par date
- Messagerie visiteurs → administrateurs
- Gestion complète des comptes
- Triggers SQL fonctionnels
- Vue SQL intégrée
- Procédure stockée utilisée dans le système de réservation

## 🗄️ Base de données utilisée

**Nom de la base** : `e22501948_db2`

**Objets SQL inclus** :

- Tables applicatives
- 2 triggers
- 1 fonction SQL
- 1 procédure stockée
- 1 vue SQL

## ⚙️ Triggers, Fonctions, Procédures et Vues

### 🔧 Triggers

| Nom | Rôle |
|-----|------|
| `t_check_jauge` | Vérifie les jauges min/max des ressources |
| `t_hash_password` | Hash automatique des mots de passe |

### 📘 Procédure stockée

**`p_reservations_by_date(date)`**  
→ Retourne les réservations de la date donnée.

### 🧩 Fonction SQL

**`f_salle_label(id)`**  
→ Retourne un libellé lisible pour une salle.

### 👁️ Vue SQL

**`v_membre_mem`**  
→ Combine données compte + membre.

## 💾 Commandes de sauvegarde

**Sauvegarde des fichiers de l'application**
```bash
zip -r resaweb_backup.zip /var/www/ResaWeb
```
    Sauvegarde de la base MySQL
```bash
    mysqldump -u root -p base_association > base_association_backup.sql
```
## 🔮 Points à améliorer / Reste à faire (V2.1)

- Fonctionnalités avancées de réservation (rôles, modification, bilans)
- Gestion des réunions (inscription, documents, CRUD)
- Gestion des indisponibilités des ressources
- Ajout/retrait d'invités sur un créneau
- Filtres supplémentaires pour les réservations
- Optimisation de l'affichage des images

## 🛠️ Procédure d'installation sur un serveur

### 📌 Prérequis

- Apache 2.4
- PHP 8.1+
- Extensions requises : intl, mbstring, mysqli
- MySQL / MariaDB
- Permissions d'écriture sur :
  - `/writable`
  - `/public/uploads`

### 📥 Étapes d'installation

#### 1️⃣ Copier le projet
```bash
cp -r ResaWeb /var/www/
```
#### 2️⃣ Importer la base SQL
```bash
mysql -u root -p < e22501948_db2.sql
```
#### 3️⃣ Configurer CodeIgniter

Éditer : `app/Config/Database.php`

```php
public $default = [
    'hostname' => 'localhost',
    'username' => 'root',
    'password' => '',
    'database' => 'base_association',
    'DBDriver' => 'MySQLi',
];
```
4#### 4️⃣ Configurer Apache

Créer un VirtualHost :

```apache
DocumentRoot /var/www/ResaWeb/public

<Directory /var/www/ResaWeb/public>
    AllowOverride All
    Require all granted
</Directory>
```

Activer les réécritures d'URL :

```bash
a2enmod rewrite
systemctl restart apache2
```
#### 5️⃣ Accéder à l'application

http://localhost/ResaWeb/public

#### 6️⃣ Connexion administrateur

Utiliser les comptes fournis dans la section 3.
