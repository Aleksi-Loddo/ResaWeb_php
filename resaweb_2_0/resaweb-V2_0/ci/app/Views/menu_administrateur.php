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
                            <i class="align-middle" data-feather="mail"></i>
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

                    <!-- ====================== -->
                    <!--  RÉSERVATIONS À VENIR  -->
                    <!-- ====================== -->
                    <h5 class="card-title mb-0">Réservations à venir</h5>

                    <table class="table table-hover my-0 mt-3">
                        <thead>
                            <tr>
                                <th>Lieu</th>
                                <th class="d-none d-xl-table-cell">Date</th>
                                <th class="d-none d-xl-table-cell">Heure</th>
                                <th>Status</th>
                                <th class="d-none d-md-table-cell">responsable</th>
                                <th class="d-none d-md-table-cell">participant</th>
                            </tr>
                        </thead>

                        <tbody>
                            <?php if (!empty($reservations_a_venir)): ?>
                                <?php foreach ($reservations_a_venir as $r): ?>
                                    <tr>
                                        <td><?= esc($r['res_lieu']) ?></td>
                                        <td class="d-none d-xl-table-cell"><?= esc($r['res_datereservation']) ?></td>
                                        <td class="d-none d-xl-table-cell"><?= esc($r['res_heuredebut']) ?></td>
                                        <td class="d-none d-xl-table-cell"><?= esc($r['res_heurefin']) ?></td>
                                        <td><span class="badge bg-warning">À venir</span></td>
                                        <td class="d-none d-md-table-cell"><?= esc($r['responsable'] ?? '-') ?></td>
                                        <td class="d-none d-md-table-cell"><?= esc($r['participants'] ?? '-') ?></td>
                                    </tr>
                                <?php endforeach; ?>
                            <?php else: ?>
                                <tr>
                                    <td colspan="7" class="text-center text-muted">Aucune réservation à venir</td>
                                </tr>
                            <?php endif; ?>
                        </tbody>
                    </table>

                    <!-- ====================== -->
                    <!--     RÉSERVATIONS PASSÉES -->
                    <!-- ====================== -->
                    <h5 class="card-title mb-0 mt-4">Réservations passées</h5>

                    <table class="table table-hover my-0 mt-3 mb-5">
                        <thead>
                            <tr>
                                <th>Lieu</th>
                                <th class="d-none d-xl-table-cell">Date</th>
                                <th class="d-none d-xl-table-cell">Heure début</th>
                                <th class="d-none d-xl-table-cell">Heure fin</th>
                                <th>Status</th>
                                <th class="d-none d-md-table-cell">Responsable</th>
                                <th class="d-none d-md-table-cell">Participants</th>
                                <th class="d-none d-md-table-cell">Bilan</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (!empty($reservations_passees)): ?>
                                <?php foreach ($reservations_passees as $r): ?>
                                    <tr>
                                        <td><?= esc($r['res_lieu']) ?></td>
                                        <td class="d-none d-xl-table-cell"><?= esc($r['res_datereservation']) ?></td>
                                        <td class="d-none d-xl-table-cell"><?= esc($r['res_heuredebut']) ?></td>
                                        <td class="d-none d-xl-table-cell"><?= esc($r['res_heurefin']) ?></td>
                                        <td><span class="badge bg-secondary">Passée</span></td>
                                        <td class="d-none d-md-table-cell"><?= esc($r['responsable'] ?? '-') ?></td>
                                        <td class="d-none d-md-table-cell"><?= esc($r['participants'] ?? '-') ?></td>
                                        <td class="d-none d-md-table-cell"><?= esc($r['res_bilanreservation'] ?? '-') ?></td>
                                    </tr>
                                <?php endforeach; ?>
                            <?php else: ?>
                                <tr>
                                    <td colspan="7" class="text-center text-muted">Aucune réservation passée</td>
                                </tr>
                            <?php endif; ?>
                        </tbody>
                    </table>

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