<?php

if (!empty($message)) {
    echo '<div style="
        margin: 50px ;
        padding: 60px 20px;
        background: #f9f9ff;
        border-radius: 12px;
        max-width:  100%;
        box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        font-family: Arial, sans-serif;
        color: #333;
        text-align: center;
        font-size: 22px; 
        line-height: 1.6; 
    ">';

    
    echo "<h2 style='color:#6c63ff; font-size:40px; font-weight:bold;'>Suivi du message</h2>";
    echo "<hr style='width:40%; margin:20px auto; border:1px solid #6c63ff;'>";

    echo "<p><strong>Code :</strong> {$message['mei_code']}</p>";
    echo "<p><strong>Email :</strong> {$message['mei_email']}</p>";
    echo "<p><strong>Titre :</strong> {$message['mei_titre']}</p>";
    echo "<p><strong>Message :</strong><br>" . nl2br($message['mei_contenu']) . "</p>";
    echo "<p><strong>Réponse :</strong><br>" . nl2br($message['mei_reponse']) . "</p>";
    echo "<p><strong>Date création :</strong> {$message['mei_datecreation']}</p>";

    echo "<p><strong>Pseudo admin :</strong> " 
        . ($pseudo ? $pseudo->com_pseudo : "Aucun (pas encore répondu)")
        . "</p>";
    echo "</div>";

} else {
    echo '<div style="
        width: 100vw;
        margin:  50px;
        padding: 60px 20px;
        background: #fff3f3;
        text-align:center;
        font-family: Arial, sans-serif;
    ">
     <h3 style="color:#cc0000; font-size:28px;">Aucun message trouvé pour ce code</h3>
    </div>';
}


?>