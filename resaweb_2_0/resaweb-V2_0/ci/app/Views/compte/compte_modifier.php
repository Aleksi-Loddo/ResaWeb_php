<?php
echo ($personne)
    ?>

<body>
    <div class="wrapper">
        <nav id="sidebar" class="sidebar js-sidebar">
            <div class="sidebar-content js-simplebar">
                <a class="sidebar-brand" href="index.html">
                    <span class="align-middle">AdminKit</span>
                </a>

                <ul class="sidebar-nav">
                    <li class="sidebar-header">Pages</li>

                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<?= site_url('compte/accueil') ?>">
                            <i class="align-middle" data-feather="sliders"></i>
                            <span class="align-middle">Dashboard</span>
                        </a>
                    </li>

                    <li class="sidebar-item active">
                        <a class="sidebar-link" href="<?= site_url('compte/afficher_profil') ?>">
                            <i class="align-middle" data-feather="user"></i>
                            <span class="align-middle">Profil</span>
                        </a>
                    </li>

                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<?= site_url('compte/deconnecter') ?>">
                            <i class="align-middle" data-feather="user-plus"></i>
                            <span class="align-middle">Déconnexion</span>
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <div class="main">
            <nav class="navbar navbar-expand navbar-light navbar-bg">
                <a class="sidebar-toggle js-sidebar-toggle">
                    <i class="hamburger align-self-center"></i>
                </a>
            </nav>

            <main class="content">
                <div class="container-fluid p-0">

                    <h1 class="h3 mb-3"><strong>Modifier mon Profil</strong></h1>

                    <?php if (session()->getFlashdata('error')): ?>
                        <div class="alert alert-danger">
                            <?= session()->getFlashdata('error') ?>
                        </div>
                    <?php endif; ?>

                    <?php if (session()->getFlashdata('success')): ?>
                        <div class="alert alert-success">
                            <?= session()->getFlashdata('success') ?>
                        </div>
                    <?php endif; ?>

                    <div class="card w-100">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Modifier mes informations</h5>
                        </div>

                        <div class="card-body">

                            <form method="post" action="<?= site_url('compte/update_profil') ?>">

                                <div class="mb-3">
                                    <label>Pseudo (non modifiable)</label>
                                    <input type="text" class="form-control" value="<?= $profil->com_pseudo ?>" disabled>
                                </div>

                                <div class="mb-3">
                                    <label>Nom</label>
                                    <input type="text" name="pro_nom" class="form-control"
                                        value="<?= $profil->pro_nom ?>" required>
                                </div>

                                <div class="mb-3">
                                    <label>Prénom</label>
                                    <input type="text" name="pro_prenom" class="form-control"
                                        value="<?= $profil->pro_prenom ?>" required>
                                </div>

                                <div class="mb-3">
                                    <label>Date de naissance</label>
                                    <input type="date" name="pro_datedenaissance" class="form-control"
                                        value="<?= $profil->pro_datedenaissance ?>">
                                </div>

                                <div class="mb-3">
                                    <label>Email</label>
                                    <input type="email" name="pro_mail" class="form-control"
                                        value="<?= $profil->pro_mail ?>" required>
                                </div>

                                <div class="mb-3">
                                    <label>Adresse</label>
                                    <input type="text" name="pro_adress" class="form-control"
                                        value="<?= $profil->pro_adress ?>">
                                </div>

                                <div class="mb-3">
                                    <label>Téléphone mobile</label>
                                    <input type="text" name="pro_telmob" class="form-control"
                                        value="<?= $profil->pro_telmob ?>">
                                </div>

                                <div class="mb-3">
                                    <label>Téléphone fixe</label>
                                    <input type="text" name="pro_telfix" class="form-control"
                                        value="<?= $profil->pro_telfix ?>">
                                </div>

                                <hr>

                                <div class="mb-3">
                                    <label>Nouveau mot de passe (laisser vide pour ne pas changer)</label>
                                    <input type="password" name="password" class="form-control"
                                        placeholder="Nouveau mot de passe">
                                </div>

                                <div class="mb-3">
                                    <label>Confirmation du mot de passe</label>
                                    <input type="password" name="confirm" class="form-control"
                                        placeholder="Confirmer le mot de passe">
                                </div>

                                <button type="submit" class="btn btn-success">Valider</button>
                                <a href="<?= site_url('compte/afficher_profil') ?>"
                                    class="btn btn-secondary">Annuler</a>


                            </form>

                        </div>
                    </div>

                </div>
            </main>

            <footer class="footer">
                <div class="container-fluid">
                    <div class="row text-muted">
                        <div class="col-6 text-start">
                            <p class="mb-0">
                                <strong>AdminKit</strong> - site fait par Aleksi Loddo
                            </p>
                        </div>
                    </div>
                </div>
            </footer>

        </div>
    </div>

    <script src="<?= base_url('bootstrap2/static/js/app.js') ?>"></script>

</body>

</html>