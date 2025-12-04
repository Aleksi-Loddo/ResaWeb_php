<?php if (session()->has('error')): ?>
    <div class="alert alert-danger">
        <?= session('error') ?>
    </div>
<?php endif; ?>

<?php if (session()->has('success')): ?>
    <div class="alert alert-success">
        <?= session('success') ?>
    </div>
<?php endif; ?>

<div class="card w-100">
    <div class="card-header">
        <h5 class="card-title mb-0">Répondre à un visiteur</h5>
    </div>
    <div class="card-body">

        <p><strong>Email :</strong> <?= esc($message['mei_email']) ?></p>
        <p><strong>Titre :</strong> <?= esc($message['mei_titre']) ?></p>
        <p><strong>Date :</strong> <?= esc($message['mei_datecreation']) ?></p>
        <p><strong>Message :</strong><br> <?= nl2br(esc($message['mei_contenu'])) ?></p>
        <p><strong>réponse :</strong> <?= esc($message['mei_reponse']) ?></p>

        <form method="post" action="<?= site_url('gestion_association/envoyer_reponse/' . $message['mei_id']) ?>">
            <div class="mb-3">
                <label for="reponse" class="form-label">Votre réponse :</label>
                <textarea name="reponse" id="reponse" class="form-control" rows="5"><?= old('reponse') ?></textarea>
            </div>

            <button type="submit" class="btn btn-primary">Répondre</button>
            <a href="<?= site_url('admin_list_message') ?>" class="btn btn-secondary ms-2">
                Annuler
            </a>
        </form>
    </div>
</div>