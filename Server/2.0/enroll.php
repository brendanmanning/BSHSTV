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
	
	$unenrolling = false;
	if(isset($_GET['unenroll'])) {
		if($_GET['userid'] != "" && $_GET['user_id'] != "1" && $_GET['user_id'] != "0") {
			$unenrolling = true;
		}
	}
	
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
	$sql = $conn->prepare("SELECT privacy,code FROM clubs WHERE internalid=:clubid");
	$sql->bindParam(":clubid", $clubid);
	$sql->execute();
	while($row=$sql->fetch()) {
		$correctpassword = (($clubpassword == $row['code']) || ($row['privacy'] == 0));
	}
	
	/* Make sure that all prerequisets are met, then proceed */
	if($unenrolling == false) {
		if($clubexists && (!$alreadyenrolled) && $correctpassword) {
			/* Insert the data */
			$sql = $conn->prepare("INSERT INTO clubmembers (clubid,userid,name) VALUES (:clubid,:userid,:username)");
			/*$sql->bindParam(":userid", $userid);
			$sql->bindParam(":clubid", $clubid);
			$sql->bindParam(":username", $username);*/
			$sucess = $sql->execute(array(":userid" => $userid, ":clubid" => $clubid, ":username" => $username));
		}
	} else {
		if($clubexists && ($alreadyenrolled)) {
			/* Some can't be unsubscribed from, make sure this isn't one */
			$required = -1;
			$sql = $conn->prepare("SELECT required FROM clubs WHERE internalid=:cid");
			$sql->bindParam(":cid", $clubid);
			$sql->execute();
			while($row=$sql->fetch()) {
				$required = $row['required'];
			}
			if($required == 0) {
				$sql = $conn->prepare("DELETE FROM clubmembers WHERE userid=:uid AND clubid=:cid LIMIT 1");
				$sucess = $sql->execute(array(":uid" => $userid, ":cid" => $clubid));
				$message = ($sucess) ? "You have been unsubscribed from " . $clubname : "You were not unsubscribed. Please try again.";
			} else {
				$sucess = false;
				$message = "Sorry, you can't unsubscribe from " . $clubname;
			}
		}
	}
		
	/* Echo a JSON array containing the status of the query */
	$status = "error";
	if(!isset($message)) {
		$message = "The server doesn't know if the previous action worked or not";
		if(!$sucess) {
			if(!$clubexists) {
				$message = "The club you tried to join does not exist (anymore??)";
			} else if($alreadyenrolled) {
				$message = "You are already enrolled in " . $clubname;
				$status = "ae";
			} else if(!$correctpassword) {
				$message = "Join code invalid";	
			}
		} else {
			$message = "You will now recieve announcements from this club";
		}
	}
	
	if($sucess) { $status = "ok"; }
	
	echo json_encode(array("status" => $status, "message" => $message));
?>