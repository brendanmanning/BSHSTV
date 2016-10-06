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
		if(!isComplete(array($_POST['prompt'],$_POST['title'],$_POST['c1'],$_POST['c2'],$_POST['c3'],$_POST['c4'],$_POST['creator'])))
		{
			header("Location: addpoll.php?notcomplete");
			exit(0);
		}
		
		// Init database connection
		$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name , $user, $pass);
	
		// set the PDO error mode to exception
    		$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    		
    		// Create SQL Statement
    		$sql = $conn->prepare("INSERT INTO polls (prompt, description, choiceOne, choiceTwo, choiceThree, choiceFour, creator, date) VALUES(:prompt,:desc,:choice_one,:choice_two,:choice_three,:choice_four,:creator,NULL)");
    		
    		// Insert values for placeholders
    		// This should help prevent SQL Injection
    		$sql->bindParam(':prompt', $_POST['prompt']);
    		$sql->bindParam(':desc', $_POST['title']);
    		$sql->bindParam(':choice_one', $_POST['c1']);
    		$sql->bindParam(':choice_two', $_POST['c2']);
    		$sql->bindParam(':choice_three', $_POST['c3']);
    		$sql->bindParam(':choice_four', $_POST['c4']);
    		$sql->bindParam(':creator', $_POST['creator']);
    	
    		if($sql->execute())
    		{
    			header("Location: index.php?ok");
    		} else {
    			header("Location: index.php?error");
    		}
    	} catch (PDOException $e) {
    		header("Location: index.php?error");
    	}
?>