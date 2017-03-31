<?php
	include 'config.php';
	try {
		$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
		$sql = "SELECT id FROM videos WHERE enabled=1";
		foreach ($conn->query($sql) as $row) {
			echo $row['id'] . ",";
		}
	} catch(PDOException $e) {
		die("ERROR IN PDO");
	}
?>