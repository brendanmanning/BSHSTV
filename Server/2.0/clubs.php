<?php
	// Include database constants
	include 'config.php';
	$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
	$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

	// Validate the API request
	require 'apivalidatorreal.php';
	$validator = new APIValidator();
	$valid = $validator->check($conn);
	if(!$valid) { echo json_encode(array("status" => 403)); } else {
		if(!isset($_GET['user'])) { echo json_encode(array("status" => 403)); } else {
		// Prepare a SQL query to list all the clubs
		$sql = $conn->prepare("SELECT internalid,title,description,admin,privacy,image FROM clubs WHERE active=1");
		/* Create an array and loop through the results adding to it */
		$arr = array();
		// Loop through database results
		$sql->execute();
		while($row=$sql->fetch()) {
			// Find if this user has joined that club
			$joinedStatus = 0; // 0: Not joined, 1: Joined, 2: Pending
			$nsql = $conn->prepare("SELECT active FROM clubmembers WHERE clubid=:cid AND userid=:uid");
			$nsql->bindParam(":cid", $row['internalid']);
			$nsql->bindParam(":uid", $_GET['user']);
			$nsql->execute();
			while($nrow=$nsql->fetch()) {
				if($nrow['active'] == 0) {
					$joinedStatus = 2;
				} else {
					$joinedStatus = 1;
				}
			}

			// Now add the information for this club to the array
			$arr[] = array("id"=> $row['internalid'], "title" => $row['title'], "description" => $row['description'], "image" => $row['image'], "admin" => $row['admin'], "private" => ($row['privacy'] == 1), "membership" => $joinedStatus);
		}

		echo json_encode($arr);
	}
	}
?>
