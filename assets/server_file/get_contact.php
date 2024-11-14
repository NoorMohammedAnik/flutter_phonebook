<?php

if ($_SERVER['REQUEST_METHOD'] == 'GET')
{
    require_once 'db_connect.php';
    $user_id = $_GET['user_id'];
    $search_text = $_GET['search'];
    
  if(strlen($search_text)>1)
  {
       $query = "SELECT * FROM contacts  WHERE user_id='$user_id' AND contact_name LIKE '%$search_text%'  OR contact_phone LIKE '%$search_text%'  OR contact_email LIKE '%$search_text%'";
  }
  
  else
  {
    $query = "SELECT * FROM contacts WHERE user_id='$user_id' ORDER BY contact_id DESC";   
  }

   


    $resultOfQuery = $con->query($query);

    if ($resultOfQuery->num_rows > 0)
    {
        $contactData = array();
        while ($rowFound = $resultOfQuery->fetch_assoc())
        {
            $contactData[] = $rowFound;
        }

        echo json_encode(array(
            "success" => true,
            "contactData" => $contactData,
        ));
    }
    else
    {
        echo json_encode(array(
            "success" => false
        ));
    }

    mysqli_close($con);

}

?>
