<?php

if ($_SERVER['REQUEST_METHOD'] == 'POST') {


    // Database connection added
    include 'db_connect.php';

    //received dat from app
    $contact_name = $_POST['contact_name'];
    $contact_email = $_POST['contact_email'];
    $contact_phone = $_POST['contact_phone'];
    $contact_id = $_POST['contact_id'];


    //Update query to update contact details in database using received contact_id
    $sqlQuery = "UPDATE contacts SET contact_name='$contact_name',contact_email='$contact_email',contact_phone='$contact_phone' WHERE contact_id='$contact_id'";


    //Execute the query and check the result
    $resultOfQuery = $con->query($sqlQuery);

    if ($resultOfQuery) {
        echo json_encode(array("success" => true));
    } else {
        echo json_encode(array("success" => false));
    }
} 
?>