<?php
	// Make sure the requestis signed
	include 'apivalidator.php';
	// Helper script for checking if user input is complete
	require 'nullcheck.php';
	
	// Includes database constants
	include 'config.php';
	// Stuff doesn't always work...
	
	try {
		$ok = false;
		/* Authenticate the request */
		if(isset($_GET['key']) && isset($_GET['secret'])) {
			if(call($_GET['key'], $_GET['secret'], $host,$name,$user,$pass)) {
				$ok = true;
			}
		}
		
		if($ok) {
			$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
			$sql = $conn->prepare("SELECT * FROM features WHERE name LIKE :n");
			$sql->execute(array(":n" => $_GET['name']));
			$results = 0;
			foreach ($sql->fetchAll() as $row) {
				$results = $results + 1;
				if($row['enabled'] == 1)
				{
					$arr = array("enabled" => true, "status" => 200);
				} else {
					$arr = array("enabled" => false, "message" => $row['disabledMessage'], "status" => 200);
				}
			}
		
			if($results == 1)
			{
				echo json_encode($arr);
			} else {
				echo json_encode(array("enabled" => true, "status" => 404));
			}
		} else {
			echo json_encode(array("enabled" => true, "status" => 403));
		}
	} catch (PDOException $e) {
		echo json_encode(array("enabled" => true, "status" => 500));
	}
?>