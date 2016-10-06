<?php

if($_POST['pwd'] != "deannoestaaqui")
		{
			die("404");
		}
	if(isset($_POST['creator']) && isset($_POST['title']) && isset($_POST['text']) && isset($_POST['image']))
	{
		include 'config.php';
		$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name , $user, $pass);
	
		// set the PDO error mode to exception
    		$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    		
    		$sql = $conn->prepare("INSERT INTO announcements (creator, title, text, image) VALUES(:creator,:title,:text,:image)");
    		$sql->bindParam(':creator', $_POST['creator']);
    		$sql->bindParam(':title', $_POST['title']);
    		$sql->bindParam(':text', $_POST['text']);
    		$sql->bindParam(':image', $_POST['image']);
    	
    		$sql->execute();
    	} else {
    		header("Location: addannouncement.php?title=" . $_POST['title'] . "&text=" . $_POST['text'] . "&image=" . $_POST['image'] . "&creator=" . $_POST['creator']);
    	}
   ?>