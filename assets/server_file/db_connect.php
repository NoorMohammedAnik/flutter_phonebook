<?php
 define('HOST','localhost');         //hostname
 define('USER','onlineso_phonebook');     //username
 define('PASS','phonebook9900#');        //user password
 define('DB','onlineso_phonebook');  //database name
 
 $con = mysqli_connect(HOST,USER,PASS,DB) or die('Unable to Connect');

?>