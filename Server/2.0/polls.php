<?php
	include 'config.php';
	try {
	$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
	$sql = "SELECT id,prompt,description,icon FROM polls";
	$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	$arr = array();
	
	foreach ($conn->query($sql) as $row)
	{
		$arr[] = array(
			"id" => $row['id'],
			"prompt" => $row['prompt'],
			"description" => $row['description'],
			"icon" => $row['icon']
		);
	}
	
	
	} catch (PDOException $e) {
		//die("Error");
		die($e->getMessage());
	}
	
	echo json_encode($arr);
?>
	