<?php
	include 'auth.php';
?>

<html>
	<head>
		<link rel="stylesheet" type="text/css" href="mainstyle.css">
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/mu/0.3.0/mu.min.css" />
	</head>

	<body>
		<?php
			if(isset($_GET['ok'])) {
				echo '<p class="green">Previous action <strong>successful!</strong></p>';
			}
			if(isset($_GET['error'])) {
				echo '<p class="red">Previous action <strong>failed!</strong></p>';
			}
		 ?>
		<h1>Club Requests</h1>
		<i>When club moderators ask to add their club to the channel 2 app, you can approve it here</i>
		<hr>
		<table class="zebra">
			<thead>
				<tr>
					<th>Club</th>
					<th>Email / Username</th>
					<th>Approve</th>
				<tr>
			</thead>
			<tbody>
				<?php
				include 'config.php';
				$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
				$sql = $conn->prepare("SELECT internalid,email,token,course FROM teachertokens WHERE approved=0 AND activated=0");
				$sql->execute();
				$ids = array();
				$mails = array();
				$tokens = array();
				$titles = array();
				$courses = array();
				while($row=$sql->fetch()) {
					$ids[] = $row['internalid'];
					$mails[] = $row['email'];
					$tokens[] = $row['token'];
					$courses[] = $row['course'];
				}
				
				for($i = 0; $i < count($ids); $i++) {
					$sql = $conn->prepare("SELECT title FROM clubs WHERE internalid=:cid");
					$sql->bindParam(":cid", $courses[$i]);
					$sql->execute();
					while($row=$sql->fetch()) {
						$titles[] = $row['title'];
					}
				}
				
				for($i = 0; $i < count($ids); $i++) {
					echo '<tr><td>' . $titles[$i] . '</td><td>' . $mails[$i] . '</td><td><form action="approveClub.php" method="POST"><input type="hidden" name="id" value="' . $ids[$i] . '"><button class="primary" type="submit">Approve</button></form></td></tr>';
				}
			?>
			</tbody>
		</table>
	</body>
</html>