<?php
	/* Make sure user is logged in or redirect */
	include 'whichauth.php';
	
	if(which() >= 1);
?>
<?php
	/* Redirect ?type=X to ?X */
	if(isset($_GET['type']))
	{
		$url = "Location: manage.php";
		if($_GET['type'] == 0)
		{
			$url .= "?announcements";
		}
		if($_GET['type'] == 1)
		{
			$url .= "?polls";
		}
		if($_GET['type'] == 2)
		{
			$url .= "?features";
		}
		if($_GET['type'] == 3)
		{
			$url .= "?videos";
		}
		if(isset($_GET['error']))
		{
			$url .= "&error";			
		}
		
		header($url);
	}
?>
<?php
	if(!isset($_GET['announcements'])) {
		if(!isset($_GET['polls'])) {
			if(!isset($_GET['features'])) {
				if(!isset($_GET['videos'])) {
					echo "A URL parameter was missing. <a href='manage.php?announcements'>Manage Announcements</a> | <a href='manage.php?polls'>Manage Polls</a> | <a href='manage.php?features'>Manage App Features</a>";
					exit(-1);
				}
			}
		}
	}
?>
<?php
	$types = array("announcements", "polls", "features", "videos");
	$getParamsSet = 0;
	for($i = 0; $i < count($types); $i++) {
		if(isset($_GET[$types[$i]])) {
			$getParamsSet++;
		}
	}
	
	if($getParamsSet != 1) {
		header("Location: manage.php");
		exit(-1);
	}
?>
<html>
	<head>
		<title>Manage 
			<?php
				if(isset($_GET['announcements']))
				{
					echo "Announcements";
				} else if(isset($_GET['polls'])) {
					echo "Polls";
				} else if(isset($_GET['features'])) {
					echo "Features";
				} else if(isset($_GET['videos'])) {
					echo "Videos";
				}
			?>
		</title>
		
		<link rel="stylesheet" type="text/css" href="mainstyle.css">
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/mu/0.3.0/mu.min.css" />
	</head>
	
	<body>
		<?php 
			if(isset($_GET['nocontrol'])) {
				echo '<p class="red"><strong>Failed! </strong>Sorry, you do not control that club!</p>';
			}
		?>
		<h2>Manage <?php
				if(isset($_GET['announcements']))
				{
					echo "Announcements";
				} else if(isset($_GET['polls'])) {
					echo "Polls";
				} else if(isset($_GET['features'])) {
					echo "Features";
				} else if(isset($_GET['videos'])) {
					echo "Videos";
				}
		?></h2>
		
		<?php
			if(isset($_GET['error'])) {
				echo "<font color='red'>An error occured changing status</font>";
			}
		?>
		<hr>
		<table class="zebra">
			<thead>
				<tr>
					<?php
						if(isset($_GET['announcements'])) {
							echo '<th>Title</th><th>Full Text</th><th>Creator</th><th>Delete</th>';
						} else if(isset($_GET['polls'])){
							echo '<th>Prompt</th><th>Description</th><th>Creator</th><th>Delete</th>';
						} else if(isset($_GET['features'])) {
							echo '<th>Feature Name</th><th>Message when unavailable</th><th>Delete</th>';
						} else if(isset($_GET['videos'])) {
							echo '<th>Video Preview</th><th>Hide/Show</th>';
						}
					?>
				</tr>
			<tbody>
			
<?php
	$arr = array();
	include 'config.php';
	try {
		$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
		$sql = "";
		if(isset($_GET['announcements'])) {
			$sql = "SELECT creator,title,text,internalid,enabled FROM announcements";
			if(which() == 2) {
				require 'UserGetter.php';
				$getter = new UserGetter($_SESSION['user_name']);
				$clubs = $getter->clubs();
				$suffix = "";
				for($i = 0; $i < count($clubs); $i++) {
					if($i == 0) {
						$suffix .= " WHERE clubid=" . $clubs[$i];
					} else {
						$suffix .= " OR clubid=" . $clubs[$i];
					}
				}
				$sql .= $suffix;
			}
		} else if(isset($_GET['polls'])){
			$sql = "SELECT prompt,description,creator,id,enabled FROM polls";	
		} else if(isset($_GET['features'])) {
			$sql = "SELECT * FROM features";
		} else if(isset($_GET['videos'])) {
			$sql = "SELECT * FROM videos";
		}
		foreach ($conn->query($sql) as $row) {
			if(isset($_GET['announcements'])) {
				if($row['enabled'] == 1) {
					echo "<tr><td>" . $row['title'] . "</td><td>" . $row['text'] . "</td><td>" . $row['creator'] . "</td><td><form action='toggle.php' method='POST'><button type='submit' class='destructive'>Hide</button><input type='hidden' name='id' value='" . $row['internalid'] . "'><input type='hidden' name='newstatus' value='0'><input type='hidden' name='type' value='0'></form><form action='deleteannouncement.php' method='POST'><input type='hidden' value='" . $row['internalid'] . "' name='id'><button type='submit'>Delete Forever</button></form></td></tr>";
				}
			
				if($row['enabled'] == 0) {
					echo "<tr><td>" . $row['title'] . "</td><td>" . $row['text'] . "</td><td>" . $row['creator'] . "</td><td><form action='toggle.php' method='POST'><button type='submit' class='primary'>Show</button><input type='hidden' name='id' value='" . $row['internalid'] . "'><input type='hidden' name='newstatus' value='1'><input type='hidden' name='type' value='0'></form><form action='deleteannouncement.php' method='POST'><input type='hidden' value='" . $row['internalid'] . "' name='id'><button type='submit'>Delete Forever</button></form></td></tr>";
				}
			} else if(isset($_GET['polls'])) {
				if($row['enabled'] == 1) {
					echo "<tr><td>" . $row['prompt'] . "</td><td>" . $row['description'] . "</td><td>" . $row['creator'] . "</td><td><form action='toggle.php' method='POST'><button type='submit' class='destructive'>Hide</button><input type='hidden' name='id' value='" . $row['id'] . "'><input type='hidden' name='newstatus' value='0'><input type='hidden' name='type' value='1'></form></td></tr>";
				}
				if($row['enabled'] == 0) {
					echo "<tr><td>" . $row['prompt'] . "</td><td>" . $row['description'] . "</td><td>" . $row['creator'] . "</td><td><form action='toggle.php' method='POST'><button type='submit' class='primary'>Show</button><input type='hidden' name='id' value='" . $row['id'] . "'><input type='hidden' name='newstatus' value='1'><input type='hidden' name='type' value='1'></form></td></tr>";
				}
			} else if(isset($_GET['features'])) {
				if($row['enabled'] == 1) {
					echo "<tr><td>" . $row['name'] . "</td><td>" . $row['disabledMessage'] . "</td><td><form action='toggle.php' method='POST'><button type='submit' class='destructive'>Disable Feature</button><input type='hidden' name='id' value='" . $row['internalid'] . "'><input type='hidden' name='newstatus' value='0'><input type='hidden' name='type' value='2'></form></td></tr>";
				}
				if($row['enabled'] == 0) {
					echo "<tr><td>" . $row['name'] . "</td><td>" . $row['disabledMessage'] . "</td><td><form action='toggle.php' method='POST'><button type='submit' class='primary'>Enable Feature</button><input type='hidden' name='id' value='" . $row['internalid'] . "'><input type='hidden' name='newstatus' value='1'><input type='hidden' name='type' value='2'></form></td></tr>";
				}
			} else if(isset($_GET['videos'])) {
				if($row['enabled'] == 1) {
					echo "<tr><td><iframe width='200' height='112' src='https://www.youtube.com/embed/" . $row['id'] . "' frameborder='0' allowfullscreen></iframe></td><td><form action='toggle.php' method='POST'><button type='submit' class='destructive'>Hide video</button><input type='hidden' name='id' value='" . $row['internalid'] . "'><input type='hidden' name='newstatus' value='0'><input type='hidden' name='type' value='3'></form></td></tr>";
				}
				if($row['enabled'] == 0) {
					echo "<tr><td><iframe width='200' height='112' src='https://www.youtube.com/embed/" . $row['id'] . "' frameborder='0' allowfullscreen></iframe></td><td><form action='toggle.php' method='POST'><button type='submit' class='primary'>Show video</button><input type='hidden' name='id' value='" . $row['internalid'] . "'><input type='hidden' name='newstatus' value='1'><input type='hidden' name='type' value='3'></form></td></tr>";
				}
			}
			
		}
	} catch (PDOException $e) {
		echo "ERROR";
	}
?>
</tbody>
</table>
</body>
</html>
	