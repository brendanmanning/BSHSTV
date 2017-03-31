<?php
	// Load config
	require 'config.php';
	
	// Load announcement lib
	require 'AnnouncementGetter.php';
	
	// Load authentication lib
	require 'whichauth.php';
	
	$authed = (which() == 1);
	
	// prepare a connection to the database
	$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
	
	// Get all the clubs which are enabled
	$sql = $conn->prepare("SELECT internalid FROMS clubs WHERE enabled=1");
	$sql->execute();
	
	// Add them to an array
	$clubs = array();
	while($row=$sql->fetch()) {
		$clubs[] = $row['internalid'];
	}
	
	$announcements = array();
	// Run an announcement getter on each club
	$getter = new AnnouncementGetter();
	for($i=0;$i<count($clubs);$i++) {
		
	}
	$gette->