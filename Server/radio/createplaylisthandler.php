<?php
	// Get config stuff
	require '../config.php';
	
	// Prepare database connection
	$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
	$sql = $conn->prepare("INSERT INTO playlists (name,creator) VALUES (:t,:c)");
	
	// Make sure all the data was filled in
	if(!isset($_POST['name']) || !isset($_POST['title'])) { die('Not all input entered'); }
	
	// Bind parameters
	$sql->bindParam(":t", strip_tags($_POST['title']));
	$sql->bindParam(":c", strip_tags($_POST['name']));

	// Execute the query
	$worked = $sql->execute();
	
	// Redirect with success/error
	if($worked) {
		header("Location: createplaylist.php?ok");
	} else {
		header("Location: createplaylist.php?error");
	}
?>