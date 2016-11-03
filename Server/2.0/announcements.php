<?php
	function main() {
		$arr = array();
		include 'config.php';
		try {
			$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
			$sql = "SELECT internalid,creator,title,text,date,image,minvisitors FROM announcements WHERE enabled = 1 AND clubid=0 ORDER BY date DESC";
			foreach ($conn->query($sql) as $row) {
				$checkins = checkinsForID($conn, $row['internalid']);
				$arr[] = array(
					"id" => $row['internalid'],
					"title" => $row['title'],
					"creator" => $row['creator'],
					"text" => $row['text'],
					"date" => $row['date'],
					"image" => $row['image'],
					"checkins" => $checkins,
					"hideCheckins" => shouldHideCheckins($checkins,$row['minvisitors'])
				);
			}
		} catch(PDOException $e) {
			echo $e->getMessage();
		}
		echo json_encode($arr);
	}
	
	function checkinsForID($conn,$id) {
		$sqlQuery = "SELECT count(*) FROM `checkins` WHERE announcementid = :id"; 
		$sql = $conn->prepare($sqlQuery); 
		$sql->bindParam(':id', $id);
		$sql->execute(); 
		$count = $sql->fetchColumn(); 
		
		return $count;
	}
	
	function shouldHideCheckins($current,$min)
	{
		return($current < $min);
	}
	
	main();
?>
	