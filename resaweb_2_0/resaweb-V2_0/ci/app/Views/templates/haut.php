<!DOCTYPE html>
<html lang="zxx">

<head>
  <meta charset="utf-8">
  <title>Agen | Bootstrap Agency Template</title>

  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="theme-name" content="agen" />

  <!-- Bootstrap -->
  <link rel="stylesheet" href="<?= base_url('bootstrap/source/plugins/bootstrap/bootstrap.min.css') ?>">
  <!-- slick slider -->
  <link rel="stylesheet" href="<?= base_url('bootstrap/source/plugins/slick/slick.css') ?>">
  <!-- themefy-icon -->
  <link rel="stylesheet" href="<?= base_url('bootstrap/source/plugins/themify-icons/themify-icons.css') ?>">
  <!-- venobox css -->
  <link rel="stylesheet" href="<?= base_url('bootstrap/source/plugins/venobox/venobox.css') ?>">
  <!-- card slider -->
  <link rel="stylesheet" href="<?= base_url('bootstrap/source/plugins/card-slider/css/style.css') ?>">
  <!-- Main Stylesheet -->
  <link rel="stylesheet" href="<?= base_url('bootstrap/source/css/style.css') ?>">

  <!-- Main Stylesheet -->
  <link rel="stylesheet" href="<?= base_url('bootstrap/source/css/style.css') ?>">

  <!--Favicon-->
  <link rel="shortcut icon" href="<?= base_url('bootstrap/source/images/favicon.ico') ?>" type="image/x-icon">
  <link rel="icon" href="<?= base_url('bootstrap/source/images/favicon.ico') ?>" type="image/x-icon">


</head>

<body>
  <!-- Full-page wrapper to allow sticky footer -->
  <div class="page-wrapper d-flex flex-column min-vh-100">

    <!-- Header -->
    <header class="navigation fixed-top nav-bg">
      <nav class="navbar navbar-expand-lg navbar-dark">
        <a class="navbar-brand" href="#">
          <img src="<?= base_url('bootstrap/source/images/logo.png') ?>" alt="Agen">
        </a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navigation"
          aria-controls="navigation" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse text-center" id="navigation">
          <ul class="navbar-nav ml-auto">
            <li class="nav-item active">
              <a class="nav-link btn btn-primary text-white px-3 py-2" href="<?= base_url('/') ?>"
                style="border-radius: 5px;">
                <i class="ti-lock mr-1"></i> Home
              </a>
            </li>
            <!--
            <li class="nav-item">
              <a class="nav-link btn btn-primary text-white px-3 py-2" href="<?= base_url('index.php/Back_office') ?>"
                style="border-radius: 5px;">
                <i class="ti-lock mr-1"></i> Admin Panel
              </a>
            </li>
            -->
            <!-- Contact -->
            <li class="nav-item">
              <a class="nav-link btn btn-primary text-white px-3 py-2" href="<?= site_url('contact') ?>"
                style="border-radius: 5px;">
                <i class="ti-email mr-1"></i> Contacter nous
              </a>
            </li>

            <!-- Suivi -->
            <li class="nav-item ">
              <a class="nav-link btn btn-primary text-white px-3 py-2"
                href="<?= site_url('MessageInvitee/saisirCode') ?>" style="border-radius: 5px;">
                <i class="ti-search mr-1"></i> Suivi de demande
              </a>
            </li>


            <!-- creation de compte-->
            <!--
            <li class="nav-item ">
              <a class="nav-link btn btn-primary text-white px-3 py-2" href="<?= site_url('compte/creer') ?>"
                style="border-radius: 5px;">
                <i class="ti-search mr-1"></i> creer un compte
              </a>
            </li>
            -->
            <!-- connexction de compte-->

            <li class="nav-item ">
              <a class="nav-link btn btn-primary text-white px-3 py-2" href="<?= site_url('compte/connecter') ?>"
                style="border-radius: 5px;">
                <i class="ti-search mr-1"></i> connection
              </a>
            </li>
            <!--  more  navigation items to be added later-->
          </ul>
        </div>
      </nav>
    </header>

    <!-- banner -->
    <section class="banner bg-cover position-relative d-flex justify-content-center align-items-center"
      data-background="<?= base_url('bootstrap/source/images/banner/banner2.jpg') ?>">
      <div class="container">
        <div class="row">
          <div class="col-12 text-center">
            <h1 class="display-1 text-white font-weight-bold font-primary">Creative Agency</h1>
          </div>
        </div>
      </div>
    </section>
    <!-- /banner -->