<?php
	require '../auth.php';
?>
<html>
	<head>
		<link rel="stylesheet" href="../mainstyle.css">
		<title>Create a Playlist</title>
	</head>
	
	<body>
		<form action="createplaylisthandler.php" method="POST">
			<input type="text" name="title" placeholder="Playlist name">
			<br>
			<input type="text" name="name" placeholder="Your Name">
			<br>
			<button type="submit" class="primary round">Create Playlist</button>
		</form>
	</body>
</html>
	