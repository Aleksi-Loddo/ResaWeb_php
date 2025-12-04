<h1 style="text-align:center; margin-top:30px;">
    <?= htmlspecialchars($titre) ?>
</h1>

<?php if (isset($news) && !empty($news)) : ?>

    <div style="
        max-width: 800px;
        margin: 40px auto;
        padding: 30px;
        background: white;
        border-radius: 12px;
        box-shadow: 0px 4px 15px rgba(0,0,0,0.1);
        font-family: 'Poppins', sans-serif;
        line-height: 1.6;
    ">

        <!-- Titre -->
        <h2 style="margin-top: 0; font-size: 28px; color:#333; font-weight:600;">
            <?= htmlspecialchars($news->act_titre) ?>
        </h2>

        <!-- Date -->
        <p style="color:#888; font-size:14px; margin-top:5px;">
             Publié le : <strong><?= htmlspecialchars($news->act_datepublication) ?></strong>
        </p>

        <hr style="margin:20px 0; border:0; border-top:1px solid #eee;">

        <!-- Description -->
        <h3 style="font-size:20px; color:#444; font-weight:500;">
            <?= htmlspecialchars($news->act_description) ?>
        </h3>

        <!-- Contenu -->
        <p style="font-size:18px; color:#555; margin-top:10px;">
            <?= nl2br(htmlspecialchars($news->act_contenue)) ?>
        </p>

        <hr style="margin:25px 0; border:0; border-top:1px solid #eee;">

        <!-- ID -->
        <p style="color:#aaa; font-size:14px; text-align:right;">
            <strong>ID :</strong> <?= htmlspecialchars($news->act_id) ?>
        </p>

    </div>

<?php else : ?>

    <p style="
        text-align:center;
        margin-top:50px;
        color:#777;
        font-size:18px;
        font-style:italic;
        font-family:'Poppins', sans-serif;
    ">
        Pas d'actualité !
    </p>

<?php endif; ?>