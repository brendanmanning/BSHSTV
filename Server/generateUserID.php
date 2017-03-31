<?php
	// Include database constants
	require 'config.php';
	
	// Make sure this request was authorized
	require 'apivalidator.php';
	
	/* Make sure API token is correct */
	if(call($_GET['key'],$_GET['secret'],$host,$name,$user,$pass)) {
	
	try {
		$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
		$loops = 0;
		$userid = 0;
		while($loops < 20) {
			/* Generate a random unique identifier */
			$userid = rand(999,9999999);
			$sql = $conn->prepare("SELECT * FROM userids WHERE userid = :userid");
			$sql->bindParam(":userid", $userid);
			$existing = 0;
			$sql->execute();
			while($row=$sql->fetch()) {
				$existing++;
				break;
			}
			
			if($existing == 0)
			{
				$loops = 21;
			}
			
			$loops++;
		}
		
		if($userid != 0) {
			/* Now that we've got a user ID that's random, put it in the database */
			$sql = $conn->prepare("INSERT INTO userids (userid) VALUES (:userid)");
			$sql->bindParam(":userid", $userid);
			if($sql->execute())
			{
				$arr = array("status" => "ok","id"=>$userid);
				echo json_encode($arr);
				
				// Account Created!
				
				// Enroll this user in all the default clubs
				require 'DefaultEnroller.php';
				$enroller = new DefaultEnroller($userid);
				$enroller->setConn($conn);
				$enroller->enrollInDefaultClubs();
			} else {
				$arr = array("status" => "error");
				echo json_encode($arr);
			}
		} else {
			$arr = array("status" => "error");
			echo json_encode($arr);
		}
	} catch(PDOException $e) {
		echo $e->getMessage();
	}
	} else {
		$arr = array("status" => "error");
		echo json_encode($arr);
	}	
?>