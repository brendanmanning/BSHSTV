<?php
	// Include database constants
	require 'config.php';
	
	// Make sure this request was authorized
	require 'apivalidator.php';
	
	try {
		$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
		$loops = 0;
		$userid = -1;
		while(true) {
			/* Generate a random unique identifier */
			$userid = rand_int(999,999999999);
			$sql = "SELECT * FROM announcements WHERE userid = :userid";
			$sql->bindParam(":userid", $userid);
			$exisiting = 0;
			foreach ($conn->query($sql) as $row) {
				$existing++;
				break;
			}
			
			$loops++;
			
			if($loops > 20) { // Stop wasting server resources
				break;
			}
		}
		
		if($userid != -1) {
			/* Now that we've got a user ID that's random, put it in the database */
			
		}
	} catch(PDOException $e) {
		echo $e->getMessage();
	}
		
?>