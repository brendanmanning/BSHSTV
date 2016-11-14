<?php
  // Make sure user is logged in
  include 'auth.php';

  // Get database constants
  include 'config.php';

  $conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
  $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

  // Get data from post
  $feedbackid = $_POST['feedback'];
  $response = $_POST['response'];
  $response .= "<hr>You are recieving this because you opted to recieve a response from BSHS TV administrators when you gave feedback to the BSHS TV app.";
  // Prepare email variables
  $email = null;

  // Get data from mysql
  $sql = $conn->prepare("SELECT email FROM feedback WHERE internalid=:intid");
  $sql->bindParam(":intid", $feedbackid);

  // Run the query
  $sql->execute();

  // Iterate over the result(s)
  while($row = $sql->fetch()) {
    $email = $row['email'];
  }

  // Make sure all the information was filled in
  if(!isset($email)) {
    header("Location: feedback.php?error");
  } else {
    // Set the subject
    $subject = "BSHS TV Feedback Reply";
    // Set the sender field to a custom value from config.php
    $headers = "From: " . $server_email . "\r\n";
    // Enable HTML email
    $headers .= "MIME-Version: 1.0" . "\r\n";
    $headers .= "Content-type:text/html;charset=UTF-8" . "\r\n";
    // BCC the admin is enabled
    if($feedback_bcc) {
      "BCC: " . $admin_email;
    }

    $success = mail($email,$subject,$response,$headers);
    header("Location: feedback.php?" . (($success) ? "success" : "error"));
  }
?>
