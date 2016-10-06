<?php
	function get() {
	$arr = array();
	include 'config.php';
	try {
	
		/* Sanitize user input */
		$date = $_GET['date'];
		if(!isset($_GET['date']))
		{
			$date = date("m-d-Y");
		}
		$dateComponents = explode("-",$date);
		
		// Check month
		if(strlen($dateComponents[0]) == 1) {
			// Convert 1-11-2016 to 01-11-2016
			$date = "0" . $dateComponents[0] . "-" . $dateComponents[1] . "-" . $dateComponents[2];
		}
		
		// Check day
		if(strlen($dateComponents[1]) == 1) {
			// Convert 01-1-2016 to 01-01-2016
			$date = explode("-",$date)[0] . "-" . "0" . $dateComponents[1] . "-" . $dateComponents[2];
		}
		
		// Check year
		if(strlen($dateComponents[2]) == 2) {
			// Convert 01-01-16 to 01-01-2016
			$date = explode("-",$date)[0] . "-" . explode("-",$date)[1] . "-20" . explode("-",$date)[2];
		}
	
		
		$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
		$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		$sql = $conn->prepare("SELECT internalid,date,song,artist,bell,game,time,at FROM today WHERE date LIKE :d");
		$sql->bindParam(':d',$date);
		$sql->execute();
		
		$resultID = 0;
		while($row=$sql->fetch()) {
			$arr[] = array(
					"song" => $row['song'],
					"artist" => $row['artist'],
					"bell" => $row['bell'],
					"game" => $row['game'],
					"time" => $row['time'],
					"location" => $row['at']
				);
			$resultsID = $row['internalid'];
		}
		
		echo json_encode($arr);
		
		return $resultsCount;
	} catch (PDOException $e) {
		die("Error");
	}
	}
	
	get();
?>