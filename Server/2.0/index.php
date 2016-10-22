<?php include 'auth.php'; ?>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="mainstyle.css">
	</head>
	
	<body>
		<!-- <h2>Greetings! This is the admin page for the BSHS TV app!</h2>
		<i>Please leave and <a href='https://www.reddit.com/r/memes'>view memes</a> if you do not belong here <strong>you need to login anyway</strong></i>
		<br>
		<strong><p class="green">If you do belong here, use the links below to do stuff</p></strong>
		
		<form action='wizard.php'>
			<button class="primary" type="submit">Use the Morning Wizard</button>
		</form>
		
		<form action='manage.php'>
			<button class="primary" type="submit">Manage Announcements/Polls</button>
		</form>-->
		
		<table class="zebra">
			<thead>
				<tr>
					<th>Function Name</th>
					<th>Open Function</th>
					<th>Advanced Feature</th>
				</tr>
			</thead>
			
			<tbody>
				<?php
					$features = array(
								array("Logout", "handlers/resetData.php", false),
								array("Use Morning Wizard", "wizard.php", false),
								array("Add Announcement", "addannouncement.php", false),
								array("Add Video", "addvideo.php", false),
								array("Add Poll", "addpoll.php", false),
								array("Add Feature", "addfeature.php", true),
								array("Show/Hide Announcements", "manage.php?announcements", false),
								array("Show/Hide Videos", "manage.php?videos", false),
								array("Show/Hide Polls", "manage.php?polls", false),
								array("Enable/Disable Features", "manage.php?features", true)
							);
					
					for($i = 0; $i < count($features); $i++) {
						echo "<tr><td>" . $features[$i][0] . "</td><td><a href='" . $features[$i][1] . "'>Open Function</a></td><td>" . ($features[$i][2] ? "Yes" : "No") . "</td></tr>";
					}
				?>
			</tbody>
		</table>
	</body>
</html>
