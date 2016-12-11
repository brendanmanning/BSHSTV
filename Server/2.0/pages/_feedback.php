<?php
	// Require database constants
	require '../config.php';
	
	// Prepare database connection
	$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name , $user, $pass);
    	$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    	
    	// Make sure the form is complete
    	$inputOk = false;
    	if(isset($_POST['name']) && isset($_POST['comment'])) {
    		if(isset($_POST['reply'])) {
    			if($_POST['reply'] == 1) {
    				if(isset($_POST['email'])) {
    					$inputOk = true;
    				}
    			}
    		} else {
    			$inputOk = true;
    		}
    	}
    	
    	// Proceed if the input is ok
    	if($inputOk) {
    		// Since we can only pass variables into bindParam, we'll evalute what to pass ahead of time
    		$emailVar = (isset($_POST['email']) ? $_POST['email'] : "NULL");
    		$replyVar = (isset($_POST['reply']) ? 1 : 0);
    		// Prepare the query
    		$sql = $conn->prepare("INSERT INTO feedback (name,email,feedback,reply) VALUES (:name,:email,:feedback,:reply)");
    		$sql->bindParam(":name", strip_tags($_POST['name']));
    		$sql->bindParam(":email", strip_tags($emailVar));
    		$sql->bindParam(":reply", strip_tags($replyVar));
    		$sql->bindParam(":feedback", strip_tags($_POST['comment']));
    		if($sql->execute()) {
    			header("Location: feedback.php?success");
    		} else {
    			header("Location: feedback.php?error");
    		}
        } else {
        	$url = "feedback.php?comment={c}&name={name}&email={email}&checked={checked}";
        	$url = str_replace("{c}", (isset($_POST['comment']) ? $_POST['comment'] : ""), $url);
        	$url = str_replace("{name}", (isset($_POST['name']) ? $_POST['name'] : ""), $url);
        	$url = str_replace("{email}", (isset($_POST['email']) ? $_POST['email'] : ""), $url);
        	$url = str_replace("{checked}", (isset($_POST['reply']) ? $_POST['reply'] : ""), $url);
        	header("Location: " . $url); 
        }	