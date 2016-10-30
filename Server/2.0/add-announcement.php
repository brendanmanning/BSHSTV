<?php
	// Make sure the user is logged in
	include 'whichauth.php';
	if(which() <= 0) {
		die("You must login first");
	}
	
	// Has a convienence method used later
	require 'nullcheck.php';
	
	// Get database constants
	require 'config.php';
	
	if(isComplete(array($_POST['title'],$_POST['text'],$_POST['image'], $_POST['m'],$_POST['d'],$_POST['y'],$_POST['hr'],$_POST['min'])))
	{
		include 'config.php';
		$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name , $user, $pass);
	
		// set the PDO error mode to exception
    		$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    		
    		// Make the date
    		$date = "";
    		if(strlen($_POST['m']) == 1)
    		{
    			$date .= "0" . $_POST['m'];
    		} else {
    			$date .= $_POST['m'];
    		}
    		
    		$date .= "-";
    		
    		if(strlen($_POST['d']) == 1)
    		{
    			$date .= "0" . $_POST['d'];
    		} else {
    			$date .= $_POST['d'];
    		}
    		
    		$date .= "-";
    		
    		if(strlen($_POST['y']) == 2)
    		{
    			$date .= "20" . $_POST['y'];
    		} else {
    			$date .= $_POST['y'];
    		}
    		
    		$date .= "-";
    		
    		if(strlen($_POST['hr']) == 1)
    		{
    			$date .= "0" . $_POST['hr'];
    		} else {
    			$date .= $_POST['hr'];
    		}
    		
    		$date .= "-";
    		
    		if(strlen($_POST['min']) == 1)
    		{
    			$date .= "0" . $_POST['min'];
    		} else {
    			$date .= $_POST['min'];
    		}
    		
    		$date .= "-";
    		
    		if($_POST['ampm'] == "AM" || $_POST['ampm'] == "am")
    		{
    			$date .= "AM";
    		} else if($_POST['ampm'] == "PM" || $_POST['ampm'] == "pm") {
    			$date .= "PM";
    		} else {
    			echo 'AM/PM Field was incorrect. <a href="addannouncement.php?title=' . $_POST['title'] . "&text=" . $_POST['text'] . "&image=" . $_POST['image'] . "&creator=" . $_POST['creator'] . '">Go back</a>';
    		}
    		
    		$min = -1;
    		if($_POST['minvisitors'] == "no") {
    			$min = 999999999; // Set it to a number so high we can never realistically reach it.
    		}
    		

    		
    		$teacherSQL = false;
    		if(isset($_POST['teacher'])) {
    			if($_POST['teacher'] == "yes") {
    				if(isset($_POST['teacherclub'])) {
    					$sql = $conn->prepare("INSERT INTO announcements (creator, title, text, image, date, minvisitors, clubid) VALUES (:creator,:title,:text,:image,:date,:m,:clubid)");
    					$sql->bindParam(":clubid", $_POST['teacherclub']);
    					
    					$nsql = $conn->prepare("SELECT title FROM clubs WHERE internalid=:cid");
    					$nsql->bindParam(":cid", $_POST['teacherclub']);
    					$nsql->execute();
					while($row=$sql->fetch()) {
						$sql->bindParam(":creator", $row['title']); break;
					}
    					
    					
    					$teacherSQL = true;
    				} else {
    				
    				}
    			} else {
    			
    			}
    		}
    		if($teacherSQL == false) {
    			$sql = $conn->prepare("INSERT INTO announcements (creator, title, text, image, date, minvisitors) VALUES(:creator,:title,:text,:image,:date,:m)");
    		}
    		if(!$teacherSQL) {
    			$sql->bindParam(':creator', $_POST['creator']);
    		}
    		$sql->bindParam(':title', $_POST['title']);
    		$sql->bindParam(':text', $_POST['text']);
    		$sql->bindParam(':image', $_POST['image']);
    		$sql->bindParam(':date', $date);
    		$sql->bindParam(':m', $min);
    	
    		if($sql->execute())
    		{
    			header("Location: addannouncement.php?ok&event=" . $_POST['title']);
    		} else {
    			header("Location: addannouncement.php?error&event=" . $_POST['title']);
    		}
    	} else {
    		header("Location: addannouncement.php?title=" . $_POST['title'] . "&text=" . $_POST['text'] . "&image=" . $_POST['image'] . "&creator=" . $_POST['creator']);
    	}
   ?>