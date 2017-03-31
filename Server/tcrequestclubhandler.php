<?php
  /* File Description
   * Adds a record to the the 'clubs' table for a club that was requested by a teacher
   * on tcrequestclub.php. It sets the active field to 0 so that it requires admin approval
   * to go live
   */

  // Require database constants
  require 'config.php';
  
  // Start session
  session_start();

  // Prepare database connection
  $conn = new PDO("mysql:host=" . $host . ";dbname=" . $name , $user, $pass);
  $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

  // Make sure all the data is set
  if(isset($_POST['name']) && isset($_POST['email']) && isset($_POST['clubname']) && isset($_POST['clubpassword'])) {
    // Strip tags from the user input
    $name = strip_tags($_POST['name']);
    $email = strip_tags($_POST['email']);
    $clubname = strip_tags($_POST['clubname']);
    $clubpassword = strip_tags($_POST['clubpassword']);
    $username = strip_tags((isset($_POST['username'])) ? $_POST['username'] : ""); 

    // Prepare default values
    $description = "This is a new club! Club moderator, you can describe your club here!";
    $image = $url . "img/default_logo.jpg";
    $privacy = 1;
    $active = 0;
    $required = 0;
    $president = "Not set";

    // Make sure the user hasn't used an email that's already taken
    $sql = $conn->prepare("SELECT * FROM users WHERE user_email LIKE :mail");
    $sql->bindParam(":mail", $email);
    $sql->execute();
    $emailOkay = true;
    while($row=$sql->fetch()) {
    	if(isset($_SESSION['user_email'])) {
    		if(strtolower($_SESSION['user_email']) != strtolower($email)) {
    			$emailOkay = false;
    		}
    	} else {
    		$emailOkay = false;
    	}
    }

    if(!$emailOkay) {
    	header("Location: tcemailtaken.html");
    	exit(0);
    }

    // Prepare the first SQL query
    $sql = $conn->prepare("INSERT INTO clubs (title,description,image,privacy,code,active,required,president) VALUES(:title,:description,:image,:privacy,:code,:active,:required,:president)");
    $sql->bindParam(":title", $clubname);
    $sql->bindParam(":description", $description);
    $sql->bindParam(":image", $image);
    $sql->bindParam(":privacy", $privacy);
    $sql->bindParam(":code", $clubpassword);
    $sql->bindParam(":active", $active);
    $sql->bindParam(":required", $required);
    $sql->bindParam(":president", $president);

    // Attempt to execute the query
    $requestSuccessful = $sql->execute();

    // If query one worked, create the next query
    if($requestSuccessful) {
      // The final thing we have to do is create an entry
      // in the 'teachertoken' table. This table contains
      // activation codes for clubs. This way we can send
      // the teacher a link with a unique URL parameter which
      // will allow them to create an account and attatch it
      // to a specific club without any extra effor on their part

      // Require the class that generates random strings
      require 'Random.php';

      // Generate a random string (20 chars long)
      $token = rand_str(20);

      // Get the id of the club we just made
      $clubid = $conn->lastInsertId();

      // Prepare the final SQL query
      $second_sql = $conn->prepare("INSERT INTO teachertokens (token, course, email, user_name) VALUES (:token, :course, :email, :uname)");
      $second_sql->bindParam(":token", $token);
      $second_sql->bindParam(":course", $clubid);
      $second_sql->bindParam(":email", $email);
      $second_sql->bindParam(":uname", $username);

      // Execute it
      $second_sql_worked = $second_sql->execute();

      if($second_sql_worked) {
        // If the query worked, check if the admin wants to get an email

        if($club_request_notification) {
          // require the Email class
          require 'Email.php';

          // Prepare a new email
          $result = send_email($admin_email, $server_email, "Club Request " . $clubname, "Hello!<br><p>This is your BSHS TV instance letting you know that a user has requested to add a club to your app.</p><br><strong><i>Request Details</i></strong><hr><ul><li><strong>Club name: </strong>" . $clubname . "</li><li><strong>Teacher Name: </strong>" . $name . "</li><li><strong>Teacher Email: </strong>" . $email . "</li></ul><br><p>Please <a href='{$url}/clubrequests.php'>login to the admin console</a> to approve/reject this club</p>");
        }

        // Redirect the user
        header("Location: tcrequestsplash.php");

        exit(1);
      }
    }
  }

  // If the user is still here, it's because of an error. Redirect them to the error page
  header("Location: tcrequestclub.php?error");
?>
