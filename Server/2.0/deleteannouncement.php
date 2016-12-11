<?php
	// Database config
	require 'config.php';

	// Authentication checker
	require 'whichauth.php';
	
	// Check authentication status
	$superuser = (isset($_SESSION['authed'])) ? ($_SESSION['authed'] == true) : false;
	$teacher = (which() == 2);
	$clubs = array();
	$clubOfPost = null;
	$hasAccessToPost = false;
	if(!$teacher && !$superuser) {
		echo "You have to be logged in to delete announcements";
	}
	
	// Prepare the database connection
 	$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
	$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	
	// Teachers can only delete their own posts, get their clubs for use later
	if($teacher && !$superuser) {
		// Prepare a SQL query to get all clubs this teacher runs
		$sql = $conn->prepare("SELECT internalid FROM clubs WHERE admin LIKE :teacher");
		$sql->bindParam(":teacher", $_SESSION['user_name']);
		$sql->execute();
		while($row=$sql->fetch()) {
			$clubs[] = $row['internalid'];
		}
	}
	
	// Get post information from the database
	$sql = $conn->prepare("SELECT clubid FROM announcements WHERE internalid=:id");
	$sql->bindParam(":id", $_POST['id']);
	$sql->execute();
	while($row=$sql->fetch()) {
		$clubOfPost = $row['clubid'];
		break;
	}
	
	// If the user is a teacher, make sure this is their club
	// Superuser can modify any post
	if(($clubOfPost != null && in_array($clubOfPost, $clubs)) || ($superuser)) {
		// we're good to go, "delete" the post
			// I say delete because we don't actually DELETE the row, instead we set active to -1 to that it will
			//.. never been seen again in the admin menu or app
		$sql = $conn->prepare("UPDATE announcements SET enabled=-1 WHERE internalid=:id");
		$sql->bindParam(":id", $_POST['id']);
		if($sql->execute()) {
			header("Location: manage.php?announcements&ok");
		} else {
			header("Location: manage.php?announcements&error");
		}
		
		exit(1);
	}
	
	header("Location: manage.php?announcements&error");
?>