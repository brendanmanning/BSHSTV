<?php
	// Redirects user if not authed
	include 'auth.php';
	
	// Helper script for checking if user input is complete
	require 'nullcheck.php';
	
	// Includes database constants
	include 'config.php';
	// Stuff doesn't always work...
	try {
		// Make sure the user filled out everything
		
		/* isComplete is a method inside nullcheck.php which accepts the following arguments
			- an array containing strings that can't be blank or null
		*/
		if(!isset($_POST['title'])) {
			header("Location: addfeature.php?error");
			exit(0);
		}
		
		if(!isset($_POST['message'])) {
			header("Location: addfeature.php?error");
			exit(0);
		}
		
		/* Make sure the user input is valid (has no spaces) */
		if (strpos($_POST['title'], ' ') !== false) {
			echo "The input cannot contain spaces* <a href='addfeature.php'>Go Back</a> <br><br><br>* The previous page should have prevented spaces from being entered<br>If you are using a browser without JavaScript, <a href='https://www.google.com/intl/en/chrome/browser/desktop/index.html'>please get a real browser</a>";
			exit(-1);
		}
		
		// Init database connection
		$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name , $user, $pass);
	
		// set the PDO error mode to exception
    		$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    		
    		/* Make sure no rows exist with this title already */
		$sql = $conn->prepare("SELECT count(*) FROM `features` WHERE name LIKE :t"); 
		$sql->bindParam(":t",$_POST['title']);
		$sql->execute(); 
		$number_of_rows = $sql->fetchColumn(); 
		if($number_of_rows != 0)
		{
			header("Location: addfeature.php?taken");
			exit(-1);
		}
    		// Create SQL Statement
    		$sql = $conn->prepare("INSERT INTO features (name, disabledMessage, enabled, created) VALUES (:name,:dm,:en,NULL)");
    		
    		$enParam = "0";
    		if(isset($_POST['enabled']) && $_POST['enabled'] == 1)
    		{
    			$enParam = "1";
    		}
    		$sql->bindParam(":en", $enParam);
    		// Insert values for placeholders
    		// This should help prevent SQL Injection
    		$sql->bindParam(':name', $_POST['title']);
    		$sql->bindParam(':dm', $_POST['message']);
    	
    		if($sql->execute())
    		{
    			header("Location: addfeature.php?ok");
    		} else {
    			header("Location: addfeature.php?error");
    		}
    	} catch (PDOException $e) {
    		header("Location: addfeature.php?error");
    	}
?>