<?php
include 'config.php';
	try {
		$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
		$sql = "SELECT bannerText FROM banner";
		$hadBanner = false;
		foreach ($conn->query($sql) as $row) {
			echo $row['bannerText'];
			$hadBanner = true;
		}
		
		if(!$hadBanner) {
			echo "Nothing";
		}
	} catch(PDOException $e) {
		die("ERROR IN PDO");
	}
?>