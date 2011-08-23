<?php
// OVH Click2Call Script
// Works with the Mac OS X AddressBook and Dolibarr for example

// SETTINGS AND INFOS
// Think about protecting access to this script with a .htaccess file for example
// For this script to work you need to configure it with your click2call credentials, you can obtain them on OVH's manager in the telephone section and then "line", "call in a click"
// You need to replace userclick2call, passclick2call and phone by your own
if(isset($_REQUEST['n'])) {
$telephone = $_GET["telephone"];
echo 'Number ' .$telephone. '<br>';
try {
 $soap = new SoapClient("https://www.ovh.com/soapi/soapi-re-1.14.wsdl");

// Parameters are to be defined below for the 3 variables
 $soap->telephonyClick2CallDo("userclick2call", "passclick2call", "phone",$_REQUEST['n'], "phone"); 

// if you call this file from your browser it will be able to tell you if everything worked fine :)
 echo "telephonyClick2CallDo successfull\n";
} catch(SoapFault $fault) {
// This will echo a success value but you can also change it to mail so you'd get a mail debug.
 echo $fault;
}
}
?>