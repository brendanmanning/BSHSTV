<?php
	include 'config.php';
	try {
	$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
	$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	$sql = $conn->prepare("SELECT choicenum FROM votes WHERE onpoll=:id");
	$sql->execute(array(":id" => $_GET['id']));
	
	$arr = array();
	
	$choiceOne =0;
	$choiceTwo =0;
	$choiceThree = 0;
	$choiceFour = 0;
	while($row=$sql->fetch()) {
		if($row['choicenum'] == 1)
		{
			$choiceOne++;
		} else if($row['choicenum'] == 2)
		{
			$choiceTwo++;
		} else if($row['choicenum'] == 3)
		{
			$choiceThree++;
		} else if($row['choicenum'] == 4)
		{
			$choiceFour++;
		}
	}
	
	// Calculate percents client side
	$total = $choiceOne+$choiceTwo+$choiceThree+$choiceFour;
	
	$arr = array(
		"1" => $choiceOne/$total,
		"2" => $choiceTwo/$total,
		"3" => $choiceThree/$total,
		"4" => $choiceFour/$total,
		"total" => $total
	);
	
	if($total == 0)
	{
		$arr = array(
			"1" => "0",
			"2" => "0",
			"3" => "0",
			"4" => "0",
			"total" => "0"
		);
	}
	
	} catch (PDOException $e) {
		//die("Error");
		die("Error");
	}
	
	echo json_encode($arr);
?>
	