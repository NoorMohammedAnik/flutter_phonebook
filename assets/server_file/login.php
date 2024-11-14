<?php

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    //include database connection
    include "db_connect.php";

    //received POST request from app
    $user_email = $_POST["user_email"];
    $user_password = md5($_POST["user_password"]);

    //query to check if user exists in the database
    $sqlQuery = "SELECT * FROM users WHERE user_email = '$user_email' AND user_password = '$user_password'";

    //execute the query and fetch the result
    $resultOfQuery = $con->query($sqlQuery);


    //check if user exists in the database
    if ($resultOfQuery->num_rows > 0) {
        //allow user to login
        $userRecord = [];

        while ($rowFound = $resultOfQuery->fetch_assoc()) {
            $userRecord[] = $rowFound;
        }

        echo json_encode([
            "success" => true,
            "userData" => $userRecord[0],
        ]);
    }
   
    else {
        echo json_encode(["success" => false]);
    }
}
?>