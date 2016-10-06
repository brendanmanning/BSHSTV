<?php
	include 'config.php';
	try {
		$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
		$sql = "SELECT id FROM videos";
		foreach ($conn->query($sql) as $row) {
			echo $row['id'] . ",";
		}
	} catch(PDOException $e) {
		die("ERROR IN PDO");
	}
?>