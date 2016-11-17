<html>
	<head>
		<link rel="stylesheet" type="text/css" href="mainstyle.css">
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/mu/0.3.0/mu.min.css" />
	</head>
	
	<body>
		<center>
			<h2>Channel 2 App Wizard</h2>
			<hr>
			<?php
				if(isset($_GET['login'])) {
					echo "<font color='#00AF33'><p>You need to login to do that</p></font>";
				}
				
				if(isset($_GET['wrong'])) {
					echo "<font color='#C40500'><p>Wrong Password</p></font>";
				}
			?>
			<?php
				session_start();
				if($_SESSION['authed'])
				{
					echo "<strong><font color='#00AF33'>You are already logged in.</strong></font><br>
						<form action='wiz.php'>
							<button type='submit'>Continue</button><i>Use if you have already made edits today</i>
						</form>
						<form action='handlers/resetData.php'><br><br>
							<button type='submit'>Reset</button><i>Click here if you havent changed anything since yesterday</i>
						</form>
					";
				} else {
					$loginform = '
			<form action="wiz.php" method="POST">
				<input type="text" placeholder="Type the password to confirm" name="pwd"> <button type="submit" class="primary outline">Login</button> <input type="hidden" name="slide" value="1">';
				if(isset($_GET['sender'])) {
					$loginform .= '<input type="hidden" name="sender" value="' . $_GET['sender'] . '">';
				}
				
				$loginform .= "</form>";
				
				echo $loginform;
			}
			?>
		</center>
	</body>
</html>