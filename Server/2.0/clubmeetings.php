<?php
	require 'config.php';
	require 'apivalidatorreal.php';
	require 'AnnouncementGetter.php';
	
	$api = new APIValidator();
	
	$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
	
	if(!$api->check($conn)) {
		echo json_encode(array("success" => false));
	}
	
	$sql = $conn->prepare("SELECT active FROM clubmembers WHERE clubid=:club AND userid:user");
	$sql->bindParam(":club", $_GET['club']);
	$sql->bindParam(":user", $_GET['user']);
	$sql->execute();
	$clubmember = false;
	while($row=$sql->fetch()) {
		if($row['active'] == 1) {
			$clubmember = true;
			break;
		}
	}
	
	if($clubmember) {
		$getter = new AnnouncementGetter();
		$announcements = $getter->forClub($_GET['club'], false);
		$array = array("success" => false,
			       "announcements" => $announcements);
		echo json_encode($array);
				
	} else {
		echo json_encode(array("success" => false));
	}
	
	$conn->close();
?>