<?php
	// Check that user is authed
	require 'whichauth.php';
	if(which() != 2 && which() == -1) {
		die("You must login first");
	}
	
	// Get database constants
	require 'config.php';
	
	// Prepare database connection
	$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name , $user, $pass);
    	$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    	
    	// Make sure all variables are set
    	$allVarsSet = true;
    	$postVars = array("title","description","privacy", "club");
    	for($i = 0; $i < count($postVars); $i++) {
    		if(!isset($_POST[$postVars[$i]])) {
    			$allVarsSet = false;
    			break;
    		}
    	}
    	
    	// Make sure if privacy is 1, a code is set
    	if(isset($_POST['privacy'])) {
    		if($_POST['privacy'] == 1) {
    			if(!isset($_POST['code'])) {
    				$allVarsSet = false;
    			}
    		}
    	}
    	
    	// If all the variables were not set, show an error message or silently redirect
    	if(!$allVarsSet) {
    		if(isset($_POST['club'])) {
    			header("Location: tcsettings.php?club=" . $_POST['club']); exit(0);
    		} else {
    			die("<p>Your request was invalid. Please use your browser's back button and try again</p>");
    		}
    	}
    	
    	// Prepare the SQL Query
    	if($_POST['privacy'] == 1) {
    		// If the club is private, we'll need to update the code
    		$sql = $conn->prepare("UPDATE clubs SET title=:title,description=:desc,privacy=:priv,code=:code WHERE internalid=:id");	
    	} else {
    		// Otherwise, we'll just leave it be
    		$sql = $conn->prepare("UPDATE clubs SET title=:title,description=:desc,privacy=:priv WHERE internalid=:id");
    	}
    	$sql->bindParam(":title", $_POST['title']);
    	$sql->bindParam(":desc", $_POST['description']);
    	$sql->bindParam(":priv", $_POST['privacy']);
    	if($_POST['privacy'] == 1) {
    		$sql->bindParam(":code", $_POST['code']);
    	}
    	$sql->bindParam(":id", $_POST['club']);
    	
    	if($sql->execute()) {
    		header("Location: tcsettings.php?club=" . $_POST['club'] . "&success");
    	} else {
    		header("Location: tcsettings.php?club=" . $_POST['club'] . "&success");
    	}
   		
   	// Close the connection
   	$conn=null;
?>