<?php
	include 'config.php';
	try {
	$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
	$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	$sql = $conn->prepare("SELECT id,prompt,description,creator,choiceOne,choiceTwo,choiceThree,choiceFour FROM polls WHERE id=:id");
	$sql->execute(array(":id" => $_GET['id']));
	
	$arr = array();
	
	while($row=$sql->fetch()) {
		$arr[] = array(
			"info" => array(
				"id" => $row['id'],
				"prompt" => $row['prompt'],
				"description" => $row['description'],
				"creator" => $row['creator']
			),
			"choices" => array(
				"1" => $row['choiceOne'],
				"2" => $row['choiceTwo'],
				"3" => $row['choiceThree'],
				"4" => $row['choiceFour']
			)
		);
	}
	
	
	} catch (PDOException $e) {
		//die("Error");
		die($e->getMessage());
	}
	
	echo json_encode($arr);
?>
	