<div class="container pt-3">
    <div class="row justify-content-center">
        <div class="col-md-8">

            <div class="bg-white p-4 shadow-sm rounded text-center">

                <h2 class="text-success mb-3">Merci, votre message a bien été envoyé </h2>

                <p class="mb-4">
                    Nous avons bien reçu votre demande.  
                    Voici votre <strong>code de suivi</strong> :
                </p>

                <?php if (!empty($code)) : ?>
                    <div class="py-3 px-4 mb-4"
                         style="display:inline-block; border-radius:8px; background:#f4f4ff; font-size:24px; font-weight:bold;">
                        <?= esc($code) ?>
                    </div>

                    <p class="mb-4">
                        Conservez ce code précieusement.  
                        Vous pourrez suivre l’avancement de votre demande en utilisant le bouton
                        <strong>“Suivi de Demande”</strong> dans le menu.
                    </p>
                <?php else : ?>
                    <p class="text-danger">
                        Aucun code de suivi n’a été généré.
                    </p>
                <?php endif; ?>

                <a href="<?= site_url('/') ?>" class="btn btn-outline-primary mt-2">
                    ⬅ Revenir à l’accueil
                </a>

                <a href="<?= site_url('MessageInvitee/saisirCode') ?>" class="btn btn-primary mt-2">
                    🔍 Aller au suivi de demande
                </a>

            </div>

        </div>
    </div>
</div>