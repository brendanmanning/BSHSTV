<?php
	require 'auth.php';
?>
<html>
	<head>
		<title>Add Feature</title>
		<link rel="stylesheet" type="text/css" href="mainstyle.css">
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/mu/0.3.0/mu.min.css" />
	</head>
	
	<body>
		<center>
		<?php
			if(isset($_GET['ok']))
			{
				echo "<p class='green big'>Sucess! Feature added!</p>";
			}
			if(isset($_GET['error'])) {
				echo "<p class='red big'>Failed! An error occured!</p>";
			}
			if(isset($_GET['error'])) {
				echo "<p class='red big'>Failed! That name is already taken</p>";
			}
		?>
		<h2>Add a Feature</h2>
		<i>The app will call the server when it is not sure whether it should show something. Use of this requires programming the app (expert only)</i>
		<hr>
		<form action="add-feature.php" method="POST">
			<center>
				<input type="text" placeholder="Feature name" class="large" name="title" required>
				<br>
				<input type="text" class="wide" placeholder="What to tell users when they don't have this feature" name="message" required>
				<br>
				<input type="checkbox" name="enabled" value="1" id="enabledBox"><label for="enabledBox">Enable this feature for users?</label>
				<br>
				<button type="submit" class="primary wide">Create Feature</button>
			</center>
		</form>
	</body>
</html>