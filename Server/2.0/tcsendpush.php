<?php
	require 'whichauth.php';
	
	if(which() != 2) {
		header("Location: login/index.php");
	}
	
	require 'ClubSelect.php';
	
	$clubSelect = new ClubSelect();
?>
<html>
	<head>
		<title>Send Push Notification</title>
		<link rel="stylesheet" href="mainstyle.css">
		
	</head>
	
	<body>
		<p><h1>Send Push Notification</h1></p>
		<form action="tcsendpushhandler.php" method="POST">
			<div class="row">
				<div class="c g2">
					<label for="title">Title</label>
					<input type="text" name="title" id="title" placeholder="Hello Club Members!" required>
				</div>
				<div class="c g2">
					<label for="message">Message</label>
					<input type="text" name="message" id="message" placeholder="There will be a meeting this Monday!" required>
				</div>
			</div>
			<br>
			<div class="row">
				<div class="c g2">
					Select Club
					<?php
						echo $clubSelect->forCurrentUser();
					?>
				</div>
				<div class="c g2">
					<button type="submit" class="primary round">Send Push Notification</button>
				</div>
			</div>
		</form>
	</body>
</html>
				