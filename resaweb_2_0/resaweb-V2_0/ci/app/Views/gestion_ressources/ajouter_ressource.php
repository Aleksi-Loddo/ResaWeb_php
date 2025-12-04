<h2>Ajouter une ressource</h2>

<?php if (session()->getFlashdata('error')): ?>
    <div class="alert alert-danger"><?= session()->getFlashdata('error') ?></div>
<?php endif; ?>

<form method="post" action="<?= site_url('ressource_ajouter') ?>">

    <div class="mb-3">
        <label>Salle</label>
        <input type="number" name="salle" class="form-control"
            requiredoninvalid="this.setCustomValidity('Veuillez remplir la jauge minimale.')"
            oninput="this.setCustomValidity('')">
    </div>

    <div class="mb-3">
        <label>Jauge minimum</label>
        <input type="number" name="jmin" class="form-control"
            requiredoninvalid="this.setCustomValidity('Veuillez remplir la jauge minimale.')"
            oninput="this.setCustomValidity('')">
    </div>

    <div class="mb-3">
        <label>Jauge maximum</label>
        <input type="number" name="jmax" class="form-control"
            requiredoninvalid="this.setCustomValidity('Veuillez remplir la jauge minimale.')"
            oninput="this.setCustomValidity('')">
    </div>

    <button type="submit" class="btn btn-primary">Ajouter</button>
    <a href="<?= site_url('ressources') ?>" class="btn btn-secondary">Annuler</a>
</form>