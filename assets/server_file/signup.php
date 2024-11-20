<?php

if ($_SERVER["REQUEST_METHOD"] == "POST") {


    //added db connection
    include "db_connect.php";

    //received data from app
    $user_name = $_POST["user_name"];
    $user_email = $_POST["user_email"];
    $user_password = md5($_POST["user_password"]);


    //checking if user email already exists in db
    $sqlQuery = "SELECT * FROM users WHERE user_email='$user_email'";

    //query execution and checking if user email already exists in db
    $resultOfQuery = $con->query($sqlQuery);

    //if user email already exists in db, send response as 'exists' else insert user data into db and send response as'success'
    if ($resultOfQuery->num_rows > 0) {

         echo json_encode(["success" => "exists"]);
    } else {


        //if user email does not exist, insert user data into db and send response as'success'
        $sqlQuery = "INSERT INTO users (user_name, user_email, user_password) VALUES ('$user_name', '$user_email', '$user_password')";


        $resultOfQuery = $con->query($sqlQuery);

        if ($resultOfQuery) {
             echo json_encode(["success" => true]);
        } else {
             echo json_encode(["success" => false]);
        }
    }
}
?>