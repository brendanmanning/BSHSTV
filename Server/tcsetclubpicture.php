<?php
	session_start();
	
	// Get required scripts
	require 'config.php';
	require 'UserGetter.php';
	require 'whichauth.php';
	
	if(which() != 2) { die("You are not logged in"); }
	if(!isset($_GET['club']) || !isset($_GET['file'])) { die("Missing url parameters"); }
	
	$club = $_GET['club'];
	$file = $_GET['file'];
	
	$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
	
	$user = new UserGetter($_SESSION['user_name']);

	if(!in_array($club, $user->clubs())) {
		die("You con't control that club.");
	}
	
	$sql = $conn->prepare("UPDATE clubs SET image=:f WHERE internalid=:club");
	$image = $url . "/" . $file;
	$sql->bindParam(":f", $image);
	$sql->bindParam(":club", $club);
	if($sql->execute()) {
		header("Location: tcsettings.php?success&club={$club}");
	} else {
		header("Location: tcsettings.php?error&club={$club}");
	}
?>