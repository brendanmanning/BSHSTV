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
	</head>
	<body>
		<?php include 'tcmenu.html'; ?>
		<h1>Hello <?php echo $name; ?>!</h1>
		<form action="addannouncement.php">
			<button type="submit">Send Club Members an Announcement</button>
		</form>
		
		<form action="tcadmin.php" method="POST">
		<i>Or Select a club to configure:</i><?php echo $clubSelect; ?><select name="page"><option value='tcsettings.php'>Change Club Settings</option><option value='tcmembers.php'>Manage Club Members</option>
		<input type="submit" value="Submit">
		</form>
	</body>
</html>