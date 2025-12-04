<section class="section">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6">

                <div class="bg-white p-4 rounded shadow-sm">
                    <!-- Titre -->
                    <h2 class="mb-4 text-center"><?= esc($titre) ?></h2>

                    <!-- Message d'erreur global (identifiants incorrects, etc.) -->
                    <?php if (session()->getFlashdata('error')): ?>
                        <div class="alert alert-danger">
                            <?= session()->getFlashdata('error') ?>
                        </div>
                    <?php endif; ?>

                    <!-- Formulaire de connexion -->
                    <?= form_open('/compte/connecter'); ?>
                        <?= csrf_field() ?>

                        <!-- Champ pseudo -->
                        <div class="mb-3">
                            <label for="pseudo" class="form-label">Pseudo</label>
                            <input 
                                type="text" 
                                name="pseudo" 
                                id="pseudo" 
                                value="<?= set_value('pseudo') ?>" 
                                class="form-control"
                            >
                            <div class="text-danger small">
                                <?= validation_show_error('pseudo') ?>
                            </div>
                        </div>

                        <!-- Champ mot de passe -->
                        <div class="mb-3">
                            <label for="mdp" class="form-label">Mot de passe</label>
                            <input 
                                type="password" 
                                name="mdp" 
                                id="mdp" 
                                class="form-control"
                            >
                            <div class="text-danger small">
                                <?= validation_show_error('mdp') ?>
                            </div>
                        </div>

                        <!-- Bouton -->
                        <button type="submit" name="submit" class="btn btn-primary w-100">
                            Se connecter
                        </button>

                    </form>
                </div>

            </div>
        </div>
    </div>
</section>