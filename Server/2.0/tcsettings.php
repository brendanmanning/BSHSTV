<?php
	// Get database constants
	require 'config.php';
	
	// Make sure user is a teacher
	require 'whichauth.php';
	if(which() != 2 && which() != -1) {
		header("Location: login/index.php"); exit(0);
	}
	
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
    	$sql = $conn->prepare("SELECT * FROM clubs WHERE internalid=:id");
    	$sql->bindParam(":id", $club);
    	
    	// Define variables for club information
    	$cName;
    	$cDesc;
    	$cPriv;
    	$cCode;
    	$cImg;
    	// Run the query and get the results
    	$sql->execute();
    	$foundAResult = false;
    	while($row=$sql->fetch()) {
    		if($row['admin'] == $_SESSION['user_name']) {
    			$foundAResult = true;
    			$cName = $row['title'];
    			$cDesc = $row['description'];
    			$cPriv = $row['privacy'];
    			$cCode = $row['code'];
    			$cActive = $row['active'];
    			$cImg = $row['image'];
    			break;
    		}
    	}
    	
    	
    	if(!$foundAResult) { echo "That club does not exist or you do not control it"; exit(0); }
    	// Found all the data, now prep the ui
?>
<html>
	<head>
		<title>Club Settings</title>
		<link rel="stylesheet" type="text/css" href="mainstyle.css">
		<script>
			function openUploadForm() {
				<?php
					echo "var club={$_GET['club']};";
				?>
					window.location="upload.php?reason=Upload a new picture for your club's icon&ul_path=img&setamp&sender=tcsetclubpicture.php%3Fclub=" + club;
			}
		</script>
	</head>
	
	<body>
		<?php include 'tcmenu.html'; ?>
		<form action="tcsettingshandler.php" method="POST" id="settings">
			<?php
				if(isset($_GET['success'])) {
					echo "<center><p class='green'>Settings Update Successful</p></center>";
				}
				
				if(isset($_GET['error'])) {
					echo "<center><p class='red'>Settings Update Failed</p></center>";
				}
			?>
			
			
			<h1>Manage Club Settings</h1><hr><i>Club Name:</i><input type="text" class="large" name="title" placeholder="Club Name Here..." value=<?php echo '"' . $cName . '"'; ?> required>
			<i>Club Image</i>
			<br>
			<img src=<?php echo "\"{$cImg}\""; ?> height="110px" width="110px" onclick="openUploadForm()">
			<br>
			<a onclick="openUploadForm()">Change Picture</a>
			<br>
			<i>Club Description</i>
			<br>
			<textarea rows="3" cols="50" name="description" form="settings" class="large" placeholder="Club Description here..." required><?php echo $cDesc; ?></textarea>
			<br>
			<i>Club Privacy - Control who can join</i>
			<br>
			<input type="radio" name="privacy" value="0" <?php if($cPriv == 0) { echo "checked"; } ?>>No Privacy (Open)<br>
			<input type="radio" name="privacy" value="1" <?php if($cPriv == 1) { echo "checked"; } ?>>Require Code <input type="text" name="code" value=<?php echo '"' . $cCode . '"'; ?> placeholder="Join Code"><br>
			<br>
			<input type="hidden" name="club" value=<?php echo '"' . $_GET['club'] . '"'; ?>>
			<button type="submit" class="wide">Make Changes</button>
		</form>
	</body>
</html>