<?php
	// Require config values
	require 'config.php';
	
	// Prepare SQL connection
	$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
	$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	
	// Make sure all url params are set
	if(!isset($_GET['userid']) || !isset($_GET['fcmid'])) 
	{
		$arr = array("message" => "Missing URL Parameters", 
			      "success" => false);
		echo json_encode($arr);
		exit(0);
	}
	
	// Validate the API request
	require 'apivalidatorreal.php';
	$validator = new APIValidator();
	if($validator->check($conn)) {
		$sql = $conn->prepare("INSERT INTO fcmids (userid,fcmid) VALUES (:userid, :fcmid) ON DUPLICATE KEY UPDATE userid=VALUES(userid),fcmid=VALUES(fcmid)");
		$sql->bindParam(":userid", $_GET['userid']);
		$sql->bindParam(":fcmid", $_GET['fcmid']);
		$success = $sql->execute();
		echo json_encode(array("message" => ($success) ? "Push Notifications Enabled" : "Error enabling push notifications", "success" => $success));
		exit(0);
		
	} else {
		echo json_encode(array("message" => "Missing API token", "success" => false));
	}
?>