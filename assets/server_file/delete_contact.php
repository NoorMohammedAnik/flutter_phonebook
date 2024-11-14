<?php

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    // Database connection added
    include 'db_connect.php';

    //received id from app
    $contact_id = $_POST['contact_id'];

    // SQL query to delete contact from the database
    $sqlQuery = "DELETE FROM contacts  WHERE contact_id='$contact_id'";

    // Execute the query
    $resultOfQuery = $con->query($sqlQuery);


    
    if ($resultOfQuery) {
        echo json_encode(array("success" => true));
    } else {
        echo json_encode(array("success" => false));
    }
} 

?>
