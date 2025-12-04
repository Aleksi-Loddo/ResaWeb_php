<div style="
    max-width: 600px;
    margin: 50px auto;
    padding: 30px;
    background: #f9f9ff;
    border-radius: 12px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    font-family: Arial, sans-serif;
    color: #333;
    text-align:center;
">

    <h2 style="color:#6c63ff;">Suivi de votre demande</h2>

    <?php
    if (isset($validation)) {
        echo '<div style="color:red; margin-bottom:10px;">';
        echo esc($validation);
        echo '</div>';
    }
    ?>

    <?= form_open('/MessageInvitee/verifierCode') ?>
    <?= csrf_field() ?>

    <label for="code_suivi">Code de suivi :</label>
    <input type="text" name="code_suivi" class="form-control mb-3">

    <input type="submit" value="Rechercher" class="btn btn-primary w-100">

    </form>

</div>
</div>
</div>