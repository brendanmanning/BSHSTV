<?php
	/* Make sure the user is logged in */
	include 'whichauth.php';
	
	/* Database constants */
	require 'config.php';
	
	// Required to make sure all POST params set
	require 'nullcheck.php';
	
	try {
		if(isComplete($_POST['id'],$_POST['newstatus'],$_POST['type']))
		{
			if(($_POST['type'] != 0) && ($_POST['type'] != 1) && ($_POST['type'] != 2) && ($_POST['type'] != 3))
			{
				header("Location: manage.php?error");
				exit(-1);
			}
			$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name , $user, $pass);
	
			// set the PDO error mode to exception
    			$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    		
    			// If this is a teacher make sure they have permission to edit this post
    			if(which() == 2) {
    				if($_POST['type'] != 0) {
    					header("Location: manage.php?notallowed");
    				}
    				// Prepare to get info about this user
    				require 'UserGetter.php';
    				$usr = new UserGetter($_SESSION['user_name']);
    				$clubs = $usr->clubs();
    				// Get the club of this announcement
    				$sql = $conn->prepare("SELECT clubid FROM announcements WHERE internalid=:id");
    				$sql->bindParam(":id", $_POST['id']);
    				$sql->execute();
    				
    				$controlsClub = false;
    				while($row=$sql->fetch()) {
    					if(in_array($row['clubid'], $clubs)) {
    						$controlsClub = true;
    						break;
    					}
    				}
    				
    				if(!$controlsClub) {
    					header("Location: manage.php?announcements&nocontrol");
    					exit(0);
    				}
    			}
    			
    			if($_POST['type'] == 0) {
    				$sql = $conn->prepare("UPDATE `announcements` SET `enabled` = :new WHERE `internalid` = :i;");
    			} else if($_POST['type'] == 1) {
    				$sql = $conn->prepare("UPDATE `polls` SET `enabled` = :new WHERE `id` = :i;");
    			} else if($_POST['type'] == 2) {
    				$sql = $conn->prepare("UPDATE `features` SET `enabled` = :new WHERE `internalid` = :i;");
    			} else if($_POST['type'] == 3) {
    				$sql = $conn->prepare("UPDATE `videos` SET `enabled` = :new WHERE `internalid` = :i;");
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