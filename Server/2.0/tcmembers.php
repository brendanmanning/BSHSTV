<?php
	// Require database constants
	require 'config.php';
	
	// Make sure the user is a teacher
	require 'whichauth.php';
	$which = which();
	if($which != 2 && $which != -1) { die("You have to be logged in to do that"); }
	
	// Prepare database connection
	$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name , $user, $pass);
    	$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	
	// Get the club id from GET
	$club = -1;
	if(isset($_GET['club'])) {
		$club = $_GET['club'];
	} else {
		die("A URL parameter was missing");
	}
	
	// Make sure this user controls this club
    	$sql = $conn->prepare("SELECT admin,title FROM clubs WHERE internalid=:id");
    	$sql->bindParam(":id", $club);

    	// Run the query and get the results
    	$sql->execute();
    	$correctUser = false;
    	while($row=$sql->fetch()) {
    		if($row['admin'] == $_SESSION['user_name']) {
    			$correctUser = true;
    			$clubTitle = $row['title'];
    			break;
    		}
    	}
    	
    	// Tell the user if this isn't their club
    	if(!$correctUser) { die("You don't control this club. Sorry :("); }
    	
    	// Select every user from the database in this club
    	$sql = $conn->prepare("SELECT name,userid,active FROM clubmembers WHERE clubid=:cid");
    	$sql->bindParam(":cid", $_GET['club']);
    	
    	// Run the query and prepare an array of the results
    	$sql->execute();
    	$users = array();
    	while($row=$sql->fetch()) {
    		$users[] = array(
    				"name" => $row['name'],
    				"id" => $row['id'],
    				"active" => $row['active']
    				); 
    	}
    	
    	// Returns the string for the table row with the specified input
    	function makeRow($name,$id,$active) {
    		$row = "<tr>";
    		$row .= "<td>" . $name . "</td>";
    		$row .= '<td><form action="toggleuser.php" method="POST"><input type="hidden" name="id" value="' . $id . '">';
    		if($active == 1) {
    			$row .= '<button type="submit" class="destructive">Ban User<input type="hidden" name="newvalue" value="0">';
    		} else if($active == 0) {
    			$row .= '<button type="submit" class="primary">Admit User<input type="hidden" name="newvalue" value="1">';
    		}
    		$row .= '</form></td></tr>';
    		
    		return $row;
    	}
    	
    	// All the data has been selected and prepared. 
    	//Below here is the HTML template with intermixed PHP to insert the data
 ?>
 
 <html>
 	<head>
 		<title>Manage Users</title>
 		<link rel="stylesheet" type="text/css" href="mainstyle.css">
	</head>
	<body>
		<?php include 'tcmenu.html'; ?>
		<h1>Manage Users in <?php echo $clubTitle; ?></h1>
		<i><?php echo $_SESSION['user_name']; ?>, here you can remove or grant users permission to recieve announcements from <?php echo $clubTitle; ?></i>
		<hr>
		<table class="zebra">
			<thead>
				<tr>
					<th>Name</th>
					<th>Change Permissions</th>
				</tr>
			</thead>
			<tbody>
				<?php
					for($i = 0; $i < count($users); $i++) {
						echo makeRow($users[$i]["name"],$users[$i]["id"],$users[$i]["active"]);
					}
				?>
			</tbody>
		</table>
	</body>
</html>