<?php
	include 'config.php';
	try {
	$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
	$sql = "SELECT id,prompt,description,icon FROM polls WHERE enabled=1";
	$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	$arr = array();
	
	$rows = array();
	foreach ($conn->query($sql) as $row)
	{
		$rows[] = $row;
	}
	
	for($i = count($rows) - 1; $i >= 0; $i--) {
		$arr[] = array(
			"id" => $rows[$i]['id'],
			"prompt" => $rows[$i]['prompt'],
			"description" => $rows[$i]['description'],
			"icon" => $rows[$i]['icon']
		);
	}
	
	
	} catch (PDOException $e) {
		//die("Error");
		die($e->getMessage());
	}
	
	echo json_encode($arr);
?>
	