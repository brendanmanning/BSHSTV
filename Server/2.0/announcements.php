<?php
	$arr = array();
	include 'config.php';
	try {
		$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
		$sql = "SELECT creator,title,text,date,image FROM announcements";
		foreach ($conn->query($sql) as $row) {
			$arr[] = array(
					"title" => $row['title'],
					"creator" => $row['creator'],
					"text" => $row['text'],
					"date" => $row['date'],
					"image" => $row['image']
				);
		}
	} catch(PDOException $e) {
		echo $e->getMessage();
	}
	echo json_encode($arr);
?>
	