<?php
	// Authenticate the teacher
	//..Starts session for us, so don't do that here
	require 'whichauth.php';
	
	if(isset($_POST['page'])) {
		header("Location: " . $_POST['page'] . "?club=" . $_POST['club']);
	} else {
		if(which() != 2) {
			header("Location: login/index.php");
		}
	
		// Require database constants
		require 'config.php';
	
		$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name , $user, $pass);
	
		// set the PDO error mode to exception
    		$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    	
    		// Prepare the arrays to save club information
    		$clubs = array();
    		$ids = array();
    	
    		// Save information about the user
    		$name = $_SESSION['user_name'];

    		// Prepare a SQL query to get every club this user oversees
    		$sql = $conn->prepare("SELECT internalid, title FROM clubs WHERE admin LIKE :username");
    		$sql->bindParam(":username", $name);

    		// Run the query and get the results
    		$sql->execute();
    		while($row=$sql->fetch()) {
    			$clubs[] = $row['title'];
    			$ids[] = $row['internalid'];
    		}
    	
    		// Prepare an HTML select tag from this data 
    		$clubSelect = "<select name='club'>";
    		for($i = 0; $i < count($clubs); $i++) {
    			$clubSelect .= "<option value='" . $ids[$i] . "'>" . $clubs[$i] . "</option>";
    		}
    		$clubSelect .= "</select>";
    	
    		// With all data fetched, start writing the interface
    	}
?>	
<html>
	<head>
		<title>Teacher Admin Page</title>
		<link rel="stylesheet" href="mainstyle.css">
	</head>
	<body>
		<?php include 'tcmenu.html'; ?>
		<h1>Hello <?php echo $name; ?>!</h1>
		<div class="row">
			<h3>Add stuff to the app</h3>
			<hr>
			<div class="c g2">
				<form action="addannouncement.php">
					<button type="submit">Send Club Members an Announcement</button>
				</form>
			</div>
			<div class="c g2">
				<form action="tcsendpush.php">
					<button type="submit">Send a Push Notification</button>
				</form>
			</div>
		</div>
		<div class="row">
			<h3>Change settings</h3>
			<hr>
			<div class="c">
				<form action="tcadmin.php" method="POST">
					<?php echo $clubSelect; ?>
					
					<select name="page">
						<option value='tcsettings.php'>Change Club Settings</option>
						<option value='tcmembers.php'>Manage Club Members</option>
					</select>
				<button type="submit" class="primary round">Submit</button>
				</form>
			</div>
		</div>
	</body>
</html>