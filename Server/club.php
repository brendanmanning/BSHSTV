<?php
	// Get database info
	include 'config.php';
	
	// Make sure club id is set
	if(!isset($_GET['club'])) { die("Club ID not set"); }
	
	$club = $_GET['club'];
	// Prepare SQL connection
	$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
	
	
	// Make sure request is authorized
	require 'apivalidatorreal.php';
	if(!((new APIValidator())->check($conn))) {
		die("Not authed");
	}
	
	// Define variables which will hold the information
	$club_id = null;
	$admin_name = null;
	$admin_email = null;
	$image = null;
	$name = null;
	$description = null;
	
	// Get basic club metadata
	$sql = $conn->prepare("SELECT internalid, title, description, image, admin FROM clubs WHERE internalid=:id");
	$sql->bindParam(":id", $_GET['club']);
	$sql->execute();
	while($row=$sql->fetch()) {
		$club_id = $row['internalid'];
		$admin_name = $row['admin'];
		$image = $row['image'];
		$name = $row['title'];
		$description = $row['description'];
	}
	
	// Get the admin's email
	require 'UserGetter.php';
	$userGetter = new UserGetter($admin_name);
	$admin_email = $userGetter->userEmail();
	
	// Get announcements for this club
	require 'AnnouncementGetter.php';
	$annGetter = new AnnouncementGetter();
	$announcements = $annGetter->forClub($club_id, false);
	
	/* Now we've got all out data, let's encode it all in JSON */
	
	// First, reformat the announcement data, getting only the stuff we need
	$modifiedAnnouncements = array();
	foreach($announcements as $ann) {
		$modifiedAnnouncements[] = array("description" => $ann['text'], "date" => $ann['date']);
	}
	
	// Now make an array for the metadata
	$metadata = array("name" => $name,
			  "description" => $description,
			  "admin" => $admin_name,
			  "image" => $image);
			  
	// Now combine those arrays
	$json = array(array("metadata" => $metadata, "meetings" => $modifiedAnnouncements));
	
	// Output to browser
	echo json_encode($json);
?>