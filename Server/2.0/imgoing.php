<?php
	function main() {
		// Validate API Key
		require 'apivalidator.php';
	
		// Includes a convienence method
		require 'nullcheck.php';
	
		// Use database constants
		require 'config.php';
	
		$success = false;
		if(isComplete(array($_GET['key'],$_GET['secret'],$_GET['user'],$_GET['event']))) {
			if(callURLForKey($_GET['key'],$_GET['secret'],$host,$name,$user,$pass,$_GET['event']))
			{
				if(alreadyCheckedIn($host,$user,$pass,$name,$_GET['event']) == false)
				{
					$success = checkIn($host,$user,$pass,$name,$_GET['event']);
				}
			}
		}
		
		if($success)
		{
			echo json_encode(array(
						"status" => "ok"
					));	
		} else {
			echo json_encode(array(
						"status" => "error"
						));
		}
	
	}
	function alreadyCheckedIn($host,$user,$pass,$name,$event)
	{
		$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
		$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		$sql = $conn->prepare("SELECT * FROM checkins WHERE `userid`=:user AND `announcementid`=:ann");
		$sql->bindParam(':user',$_GET['user']);
		$sql->bindParam(':ann',$event);
		$sql->execute();
		while($row=$sql->fetch()) {
			return true;
		}
		
		return false;
	}
	
	function checkIn($host,$user,$pass,$name,$event)
	{
		$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
		$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		$sql = $conn->prepare("INSERT INTO checkins (announcementid,userid) VALUES (:a,:u)");
		$sql->bindParam(':u',$_GET['user']);
		$sql->bindParam(':a',$event);
		return ($sql->execute());
	}
	
	main();
?>
	
	