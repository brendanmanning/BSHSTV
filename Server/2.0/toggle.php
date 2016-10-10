<?php
	/* Make sure the user is logged in */
	include 'auth.php';
	
	/* Database constants */
	require 'config.php';
	
	// Required to make sure all POST params set
	require 'nullcheck.php';
	
	try {
		if(isComplete($_POST['id'],$_POST['newstatus'],$_POST['type']))
		{
			if(($_POST['type'] != 0) && ($_POST['type'] != 1))
			{
				header("Location: manage.php?error&type=0");
				exit(-1);
			}
			$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name , $user, $pass);
	
			// set the PDO error mode to exception
    			$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    		
    			if($_POST['type'] == 0) {
    				$sql = $conn->prepare("UPDATE `announcements` SET `enabled` = :new WHERE `internalid` = :i;");
    			} else if($_POST['type'] == 1) {
    				$sql = $conn->prepare("UPDATE `polls` SET `enabled` = :new WHERE `id` = :i;");
    			}
    			$sql->bindParam(':new', $_POST['newstatus']);
    			$sql->bindParam(':i', $_POST['id']);
    		
    			$sql->execute();
    			header("Location: manage.php?type=" . $_POST['type']);
		}
	} catch (PDOException $e) {
		header("Location: manage.php?error&type=" . $_POST['type']);
	}
?>