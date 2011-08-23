<?php

// Protégez ce script à votre convenance par exemple avec un .htaccess restreint à votre IP internet.
$telephone = $_GET["telephone"];
echo 'Number ' .$telephone. '<br>';
try {
 $soap = new SoapClient("https://www.ovh.com/soapi/soapi-re-1.14.wsdl");

 //telephonyClick2CallDo si tout va bien ...
 $soap->telephonyClick2CallDo("userclick2call", "passclick2call", "phone",$_REQUEST['n'], "phone"); // paramétrer ses identifiants Click2Call : ils se créent dans le manager puis ligne => appeler en un clic => modifier => nouvelle autorisation.
 echo "telephonyClick2CallDo successfull\n";
} catch(SoapFault $fault) {
// si erreur on explique .. et pour débuguer : emailez vous le résultat :)
 echo $fault;
}
?>