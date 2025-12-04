<div class="container py-5">
    <div class="row justify-content-center">

        <div class="col-md-6">
            <div class="bg-white p-4 shadow-sm rounded">

                <h3 class="mb-4 text-primary">Contactez-nous</h3>

                <?php
                if (isset($validation)) {
                    echo '<div class="alert alert-danger">';
                    echo $validation->listErrors();
                    echo '</div>';
                }
                ?>

                <!-- Formulaire Contact -->
                <form action="<?= site_url('contact/envoyer') ?>" method="post">


                    <!-- Email -->
                    <div class="mb-3">
                        <input type="text" id="email" name="email" class="form-control px-0"
                            placeholder="Adresse email">
                    </div>

                    <!-- Titre -->
                    <div class="mb-3">
                        <input type="text" id="titre" name="titre" class="form-control px-0"
                            placeholder="Titre de votre message">
                    </div>

                    <!-- Message -->
                    <div class="mb-3">
                        <textarea name="message" id="message" class="form-control px-0" placeholder="Votre message..."
                            rows="5"></textarea>
                    </div>

                    <!-- Bouton -->
                    <button class="btn btn-primary w-100" type="submit">Envoyer</button>

                </form>

            </div>
        </div>

    </div>
</div>