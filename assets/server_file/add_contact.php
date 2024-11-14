<?php

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    
    //include database connection
    include "db_connect.php";

    // Received data from app with post request
    $contact_name = $_POST["contact_name"];
    $contact_email = $_POST["contact_email"];
    $contact_phone = $_POST["contact_phone"];
    $user_id = $_POST["user_id"];

   //sql command for insert
   $sqlQuery = "INSERT INTO contacts (contact_name, contact_email, contact_phone, user_id) VALUES ('$contact_name', '$contact_email', '$contact_phone', '$user_id')";

    //execute sql command
    $resultOfQuery = $con->query($sqlQuery);

    if ($resultOfQuery) {
        echo json_encode(["success" => true]);
    } else {
        echo json_encode(["success" => false]);
    }
}

?>
