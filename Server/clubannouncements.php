<?php
	function main() {
		$arr = array();
		include 'config.php';
		try {
			if(!isset($_GET['userid'])) { die("User id not set"); }
			$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
			$commandSuffix = getAnnouncementSQLSuffixForUserID($_GET['userid'], $conn);
			
			if(isset($_GET['token'])) {
				$sql = $conn->prepare("SELECT user_name FROM tokens WHERE token LIKE :tok");
				$sql->bindParam(":tok", $_GET['token']);
				$sql->execute();
				
				while($row=$sql->fetch()) {
					$username = $row['user_name'];
				}
			}
			$username = null;
			
			
			$clubsAdmins = array();
			
			if($username != null) {
				$sql = $conn->prepare("SELECT internalid FROM clubs WHERE admin LIKE :uname");
				$sql->bindParam(":uname", $username);
				$sql->execute();
				while($row=$sql->fetch()) {
					$clubsAdmins[] = $row['internalid'];
				}
			}
			
			$sql = "SELECT internalid,creator,title,text,date,image,minvisitors,clubid FROM announcements WHERE enabled=1 " . $commandSuffix . " ORDER BY date DESC";
			
			foreach ($conn->query($sql) as $row) {
				$checkins = checkinsForID($conn, $row['internalid']);
				$arr[] = array(
					"id" => $row['internalid'],
					"title" => $row['title'],
					"creator" => $row['creator'],
					"text" => $row['text'],
					"date" => ((isset($_GET['niceformatting'])) ? date_format(date_create_from_format("m-d-Y-h-i-A", strtolower($row['date'])), "l, F jS @ h:i A") : $row['date']),
					"image" => $row['image'],
					"checkins" => $checkins,
					"hideCheckins" => shouldHideCheckins($checkins,$row['minvisitors']),
					"isAdmin" => ($username != null) ? in_array($row['clubid'], $clubsAdmins) : false
				);
			}
			
			if(isset($_GET['meetingformatting'])) {
				for($i = 0; $i < count($arr); $i++) {
					$arr[$i] = array(
						"id" => $arr[$i]["id"],
						"title" => $arr[$i]["title"],
						"date" => $arr[$i]["date"],
						"isAdmin" => $arr[$i]["isAdmin"]
						);
				}
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
		if(!isset($_GET['club'])) {
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
		} else {
			$suffix = "AND clubid=" . $_GET['club'];
		}
		
		return $suffix;
	}
	
	
	main();
?>
	