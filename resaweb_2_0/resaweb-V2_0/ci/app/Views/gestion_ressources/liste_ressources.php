<body>
    <div class="wrapper">

        <!-- SIDEBAR -->
        <nav id="sidebar" class="sidebar js-sidebar">
            <div class="sidebar-content js-simplebar">
                <a class="sidebar-brand" href="#">
                    <span class="align-middle">AdminKit</span>
                </a>

                <ul class="sidebar-nav">
                    <li class="sidebar-header">Pages</li>

                    <li class="sidebar-item active">
                        <a class="sidebar-link" href="<?= site_url('compte/dashboard-admin') ?>">
                            <i class="align-middle" data-feather="sliders"></i>
                            <span class="align-middle">Dashboard</span>
                        </a>
                    </li>

                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<?= site_url('compte/afficher_profil') ?>">
                            <i class="align-middle" data-feather="user"></i>
                            <span class="align-middle">Profil</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<?= site_url('crenaux') ?>">
                            <i class="align-middle" data-feather="calendar"></i>
                            <span class="align-middle">Creneaux</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<?= site_url('admin_gestion_membres') ?>">
                            <i class="align-middle" data-feather="user"></i>
                            <span class="align-middle">Comptes/Profils</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<?= site_url('ressources') ?>">
                            <i class="align-middle" data-feather="layers"></i>
                            <span class="align-middle">Gestion des ressources</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<?= site_url('admin_list_message') ?>">
                            <i class="align-middle" data-feather="user"></i>
                            <span class="align-middle">Contact</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<?= site_url('compte/deconnecter') ?>">
                            <i class="align-middle" data-feather="log-out"></i>
                            <span class="align-middle">Déconnexion</span>
                        </a>
                    </li>

                </ul>
            </div>
        </nav>

        <!-- MAIN -->
        <div class="main">

            <!-- NAVBAR -->
            <nav class="navbar navbar-expand navbar-light navbar-bg">
                <a class="sidebar-toggle js-sidebar-toggle">
                    <i class="hamburger align-self-center"></i>
                </a>

                <div class="navbar-collapse collapse">
                    <ul class="navbar-nav navbar-align">

                        <li class="nav-item dropdown">
                            <a class="nav-icon dropdown-toggle" href="#" data-bs-toggle="dropdown">
                                <div class="position-relative">
                                    <i class="align-middle" data-feather="bell"></i>
                                    <span class="indicator">4</span>
                                </div>
                            </a>
                        </li>

                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-none d-sm-inline-block" href="#"
                                data-bs-toggle="dropdown">
                                <img src="<?= base_url('bootstrap2/static/img/avatars/avatar.jpg') ?>"
                                    class="avatar img-fluid rounded me-1">
                                <span class="text-dark"><?= esc(session()->get('user')) ?></span>
                            </a>
                            <div class="dropdown-menu dropdown-menu-end">
                                <a class="dropdown-item" href="<?= site_url('compte/afficher_profil') ?>">Profil</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="<?= site_url('compte/deconnecter') ?>">Déconnexion</a>
                            </div>
                        </li>

                    </ul>
                </div>
            </nav>

            <!-- PAGE CONTENT -->
            <main class="content">
                <div class="container-fluid p-0">

                    <h1 class="h3 mb-3"><strong>Gestion des ressources</strong></h1>

                    <!--  Bouton Ajouter une ressource -->
                    <a href="<?= site_url('ressource_ajouter') ?>" class="btn btn-success mb-3">
                        + Ajouter une ressource
                    </a>

                    <div class="row">

                        <?php if (empty($ressources)): ?>
                            <p class="text-center text-muted">Aucune ressource réservable pour l'instant !</p>
                        <?php else: ?>

                            <?php foreach ($ressources as $r): ?>
                                <?php
                                $photo = !empty($r['rsc_photo'])
                                    ? 'image_ressources/' . $r['rsc_photo']
                                    : 'image_ressources/salle_default.jpg';
                                ?>

                                <div class="col-md-4 mb-4">
                                    <div class="card shadow-sm">

                                        <img src="<?= base_url($photo) ?>" class="card-img-top"
                                            style="height:200px;object-fit:cover;">

                                        <div class="card-body">
                                            <h5 class="card-title"> <?= esc($r['salle_nom']) ?></h5>

                                            <p class="card-text mb-1"><strong>Jauge min :</strong>
                                                <?= esc($r['rsc_jaugemin']) ?></p>
                                            <p class="card-text mb-2"><strong>Jauge max :</strong>
                                                <?= esc($r['rsc_jaugemax']) ?></p>

                                            <a href="#" class="btn btn-primary btn-sm disabled">Voir détails</a>

                                            <!--Bouton supprimer -->
                                            <a href="<?= site_url('ressource_supprimer/' . $r['rsc_id']) ?>"
                                                class="btn btn-danger btn-sm mt-2"
                                                onclick="return confirm('Voulez-vous vraiment supprimer cette ressource ?');">
                                                Supprimer
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            <?php endforeach; ?>

                        <?php endif; ?>

                    </div>
            </main>

            <!-- FOOTER -->
            <footer class="footer">
                <div class="container-fluid">
                    <div class="row text-muted">
                        <div class="col-6 text-start">
                            <p class="mb-0">&copy; AdminKit</p>
                        </div>
                    </div>
                </div>
            </footer>

        </div><!-- END MAIN -->

    </div><!-- END WRAPPER -->

    <script src="<?= base_url('bootstrap2/static/js/app.js') ?>"></script>
</body>

</html>