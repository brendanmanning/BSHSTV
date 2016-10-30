<?php
	function main() {
		$arr = array();
		include 'config.php';
		try {
			if(!isset($_GET['userid'])) { die("User id not set"); }
			$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
			$commandSuffix = getAnnouncementSQLSuffixForUserID($_GET['userid'], $conn);
			$sql = "SELECT internalid,creator,title,text,date,image,minvisitors FROM announcements WHERE 1 " . $commandSuffix . " ORDER BY date DESC";
			echo $sql;
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
	
	function getAnnouncementSQLSuffixForUserID($userid, $conn) {
		$suffix = "AND (clubid=0";
		$sql = $conn->prepare("SELECT * FROM clubmembers WHERE `userid` = :id");
		$sql->bindParam(":id", $userid);
		$sql->execute();
		while ($row=$sql->fetch()) {
			if($row['active'] == 1) {
				$suffix .= " OR clubid=" . $row['clubid'];	
			}
		}
		$suffix .= ")";
		
		return $suffix;
	}
	
	main();
?>
	