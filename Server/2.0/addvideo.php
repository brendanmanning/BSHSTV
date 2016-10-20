<?php
	include 'auth.php';
?>
<html>
	<head>
		<title>Add Video</title>
		<link rel="stylesheet" type="text/css" href="mainstyle.css">
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/mu/0.3.0/mu.min.css" />
	</head>
	<body>
		<center>
		<h1>Add a video</h1>
		<i>Paste the YouTube URL here. It should look like <br><strong>https://www.youtube.com/watch?v=XXXXXXXXXXX</strong> <br>OR<br><strong>https://youtu.be/XXXXXXXXXXX</strong></i>
		<hr>
	<form action="add-video.php" method="POST">
		<input type="text" placeholder="YouTube Video URL" name="url" class="wide" required>
		<br><br>
		<button type="submit" class="primary most">Submit</button>
		</center>
	</form>
</body>
</html>