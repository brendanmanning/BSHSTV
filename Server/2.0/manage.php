<?php
	/* Make sure user is logged in or redirect */
	include 'auth.php';
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
			echo "A URL parameter was missing. <a href='manage.php?announcements'>Manage Announcements</a> | <a href='manage.php?polls'>Manage Polls</a>";
			exit(-1);
		}
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
				}
			?>
		</title>
		
		<link rel="stylesheet" type="text/css" href="mainstyle.css">
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/mu/0.3.0/mu.min.css" />
	</head>
	
	<body>
		<h2>Manage <?php
				if(isset($_GET['announcements']))
				{
					echo "Announcements";
				} else if(isset($_GET['polls'])) {
					echo "Polls";
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
		} else if(isset($_GET['polls'])){
			$sql = "SELECT prompt,description,creator,id,enabled FROM polls";	
		}
		foreach ($conn->query($sql) as $row) {
			if(isset($_GET['announcements'])) {
				if($row['enabled'] == 1) {
					echo "<tr><td>" . $row['title'] . "</td><td>" . $row['text'] . "</td><td>" . $row['creator'] . "</td><td><form action='toggle.php' method='POST'><button type='submit' class='destructive'>Hide</button><input type='hidden' name='id' value='" . $row['internalid'] . "'><input type='hidden' name='newstatus' value='0'><input type='hidden' name='type' value='0'></form></td></tr>";
				}
			
				if($row['enabled'] == 0) {
					echo "<tr><td>" . $row['title'] . "</td><td>" . $row['text'] . "</td><td>" . $row['creator'] . "</td><td><form action='toggle.php' method='POST'><button type='submit' class='primary'>Show</button><input type='hidden' name='id' value='" . $row['internalid'] . "'><input type='hidden' name='newstatus' value='1'><input type='hidden' name='type' value='0'></form></td></tr>";
				}
			} else if(isset($_GET['polls'])) {
				if($row['enabled'] == 1) {
					echo "<tr><td>" . $row['prompt'] . "</td><td>" . $row['description'] . "</td><td>" . $row['creator'] . "</td><td><form action='toggle.php' method='POST'><button type='submit' class='destructive'>Hide</button><input type='hidden' name='id' value='" . $row['id'] . "'><input type='hidden' name='newstatus' value='0'><input type='hidden' name='type' value='1'></form></td></tr>";
				}
				if($row['enabled'] == 0) {
					echo "<tr><td>" . $row['prompt'] . "</td><td>" . $row['description'] . "</td><td>" . $row['creator'] . "</td><td><form action='toggle.php' method='POST'><button type='submit' class='primary'>Show</button><input type='hidden' name='id' value='" . $row['id'] . "'><input type='hidden' name='newstatus' value='1'><input type='hidden' name='type' value='1'></form></td></tr>";
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
	