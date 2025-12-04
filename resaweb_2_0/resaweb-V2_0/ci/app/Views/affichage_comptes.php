<h2><?php echo $titre; ?></h2>
<?php
if (! empty($logins) && is_array($logins))
{

echo"<br />";
echo " nombre de compte";
echo"<br />";
echo " -- ";
echo $num_compte->total;
echo " -- ";
echo"<br />";
echo " ------------------ ";


foreach ($logins as $pseudos)
{
echo "<br />";
echo " -- ";
echo "";
echo $pseudos["com_pseudo"];
echo " -- ";
echo "<br />";
}
}
else {
 echo("<h3>Aucun compte pour le moment</h3>");
}
?>
