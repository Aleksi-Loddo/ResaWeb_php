
<div style="
    max-width: auto;
    margin: 50px auto;
    padding: 30px;
    background: #f9f9ff;
    border-radius: 12px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    font-family: Arial, sans-serif;
    color: #333;
    font-aize: 30px;
    text-align:center;
">


<h2 style="font-size: 50px;"><?php echo $titre; ?></h2>
<?= session()->getFlashdata('error') ?>

<div>
    <?php
    //  **<?= validation_list_errors()  **  
    // Création d’un formulaire qui pointe vers l’URL de base + /compte/creer
    echo form_open('/compte/creer'); ?>
    <?= csrf_field() ?>
    <label for="pseudo" style="font-size: 40px;">Pseudo : </label>
    <input  type="input" name="pseudo" style="font-size: 32px;">
    <?= validation_show_error('pseudo') ?>
    <label for="mdp" style="font-size: 40px;">Mot de passe : </label>
    <input type="password" name="mdp" style="font-size: 32px;">
    <?= validation_show_error('mdp') ?>
    <input type="submit" name="submit" value="Créer un nouveau compte" style="font-size: 30px;">
    </form>


</div>
</div>
