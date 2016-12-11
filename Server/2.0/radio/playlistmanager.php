<?php
	require '../auth.php';
	
	require 'Playlist.php';
	
	require 'Song.php';
	
	require '../config.php';
	
	$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
	
	$playlist = new Playlist();
	$playlist->setConn($conn);
	$id = $_GET['id'];
	$playlist->setID($id);
	$playlist->fillMetadata();
	$songs = $playlist->getSongs();
?>	
<html>
	<head>
		<link rel="stylesheet" href="../mainstyle.css">
		<title>Manage <?php echo $playlist->getName(); ?></title>
	</head>
	<body>
		<table class="bordered">
			<thead>
				<tr>
					<th>Name</th>
					<th>Artist</th>
					<th>Album</th>
					<th>Thumbnail</th>
					<th>Manage</th>
				</tr>
			</thead>
			<tbody>
				<?php	