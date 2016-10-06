<?php
	require 'config.php';
	include 'apivalidator.php';
	/*if(call($_GET['key'],$_GET['secret'],$host,$name,$user,$pass))
	{
		die("OK");
	} else {
		die("FAIL");
	}*/
	$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name , $user, $pass);
	// set the PDO error mode to exception
    	$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    		
    	$sql = $conn->prepare("INSERT INTO votes (onpoll,choicenum) VALUES(:poll,:choice)");
   	$sql->bindParam(':poll', $_GET['id']);
   	$sql->bindParam(':choice', $_GET['choice']);
   	
   	$result_arr = array();
   	if(!$sql->execute())
   	{
   		$result_arr = array(
   			"status" => "error"
   			);
   	} else {
   		$result_arr = array(
   			"status" => "ok"
   			);
   	}
   	
   	echo json_encode($result_arr);
 ?>