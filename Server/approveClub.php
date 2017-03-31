<?php
	if(!isset($_POST['id'])) { die("missing url param"); }

	// Make sure user is logged in
	require 'auth.php';
	
	// Require database constants
	require 'config.php';
	
	// Prepare MySQL
	$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
	$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	
	// Get the club's teacher token row
	$sql = $conn->prepare("SELECT * FROM teachertokens WHERE internalid=:id AND activated=0");
	$sql->bindParam(":id", $_POST['id']);
	
	// Prepare vars
	$email = null;
	$course = null;
	$token = null;
	$title = null;
	
	// Execute and loop over result
	$sql->execute();
	while($row=$sql->fetch()) {
		$email = $row['email'];
		$course = $row['course'];
		$token = $row['token'];
		break;
	}
	
	if(!isset($email) || !isset($course) || !isset($token)) { die("Error"); }
	
	// We've got all the info we need now, but it might be nice to include
	// some information about the club in our email, so get that from the
	// clubs database here
	$sql = $conn->prepare("SELECT title FROM clubs WHERE internalid=:cid");
	$sql->bindParam(":cid", $course);
	$sql->execute();
	while($row=$sql->fetch()) {
		$title = $row['title'];
		break;
	}
	
	if(!isset($title)) { die("Error getting club info"); }
	
	// Create the email template
	$body = "Hello!<br>Your request to add " . $title . " to the <a href='https://bshstv.com/'>BSHS TV App</a> was approved!<hr><strong>To get started, <a href='" . $url . "login/register.php?token=" . $token . "'>click here to sign up and link your club</a>";
	// Create the subject line
	$subject = $title . " added to the Channel 2 App!";
	
	// Email is generated. Now send it!
	require 'Email.php';
	
	if(!send_email($email, $server_email, $subject, $body)) {
		echo "Error sending email...";
	} else {
		// Last but not least, we have to set the approved column to 1 so that we don't have to see
		// this in the admin UI again
		$sql = $conn->prepare("UPDATE teachertokens SET approved=1 WHERE internalid=:id");
		$sql->bindParam(":id", $_POST['id']);
		$sql->execute();
		
		// Now redirect the user
		header("Location: clubrequests.php?ok");
	}
?>