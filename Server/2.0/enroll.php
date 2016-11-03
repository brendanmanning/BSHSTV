<?php
	
	/* ********** GET PARAMETERS ********** */
	/* $_GET['userid']                      */
	/* $_GET['username']                    */
	/* $_GET['clubid']                      */
	/* $_GET['clubpassword']                */
	/* $_GET['apikey']                      */
	/* $_GET['apisecret']                   */
	/* ********** GET PARAMETERS ********** */
	$userid = $_GET['userid'];
	$username = $_GET['username'];
	$clubid = $_GET['clubid'];
	$clubpassword = $_GET['clubpassword'];
	$apikey = $_GET['apikey'];
	$apisecret = $_GET['apisecret'];
	
	$clubexists = false;
	$alreadyenrolled = false;
	$correctpassword = false;
	$clubname = "Unnamed Club";
	$sucess = false;
	/* Required files */
	require 'config.php';
	
	/* Prepare database connection */
	$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
	$conn->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );
	/* Make sure the club exists */
	$sql = $conn->prepare("SELECT active,title FROM clubs WHERE internalid=:clubid");
	$sql->bindParam(":clubid", $clubid);
	$sql->execute();
	while($row=$sql->fetch()) {
		if($row['active'] == 1) {
			$clubexists = true;
			$clubname = $row['title'];
			break;
		}
	}
	
	/* Make sure the user isn't already enrolled */
	$sql = $conn->prepare("SELECT clubid FROM clubmembers WHERE userid=:userid");
	$sql->bindParam(":userid", $userid);
	$sql->execute();
	while($row=$sql->fetch()) {
		if($row['clubid'] == $clubid) {
			$alreadyenrolled = true;
			break;
		}
	}
	
	/* Check if the password is correct */
	$sql = $conn->prepare("SELECT code FROM clubs WHERE internalid=:clubid");
	$sql->bindParam(":clubid", $clubid);
	$sql->execute();
	while($row=$sql->fetch()) {
		$correctpassword = ($clubpassword == $row['code']);
	}
	
	/* Make sure that all prerequisets are met, then proceed */
	if($clubexists && (!$alreadyenrolled) && $correctpassword) {
		/* Insert the data */
		$sql = $conn->prepare("INSERT INTO clubmembers (clubid,userid,name) VALUES (:clubid,:userid,:username)");
		/*$sql->bindParam(":userid", $userid);
		$sql->bindParam(":clubid", $clubid);
		$sql->bindParam(":username", $username);*/
		$sucess = $sql->execute(array(":userid" => $userid, ":clubid" => $clubid, ":username" => $username));
	}
	
	/* Echo a JSON array containing the status of the query */
	$status = "error";
	$message = "The server doesn't know if the previous action worked or not";
	if(!$sucess) {
		if(!$clubexists) {
			$message = "The club you tried to join does not exist (anymore??)";
		} else if($alreadyenrolled) {
			$message = "You are already enrolled in " . $clubname;
		} else if(!$correctpassword) {
			$message = "Join code invalid";	
		}
	} else {
		$message = "You will now recieve announcements from this club";
		$status = "ok";
	}
	
	echo json_encode(array("status" => $status, "message" => $message));
?>