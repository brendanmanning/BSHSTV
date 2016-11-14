
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
			if(isset($_GET['success'])) {
				echo '<p class="green">Previous action <strong>successful!</strong></p>';
			}
			if(isset($_GET['error'])) {
				echo '<p class="red">Previous action <strong>failed!</strong></p>';
			}
		 ?>
		<h1>Respond to feedback</h1>
		<i>Feedback users have given can be responded to here</i>
		<hr>
		<table class="zebra">
			<thead>
				<tr>
					<th>Name</th>
					<th>Comment</th>
					<th>Respond</th>
				<tr>
			</thead>
			<tbody>
			<?php
				include 'config.php';
				$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
				$sql = "SELECT internalid,name,feedback FROM feedback WHERE finished=0";

				foreach ($conn->query($sql) as $row) {
					echo '<tr><td>' . $row['name'] . '</td><td>' . $row['feedback'] . '</td><td><form action="feedbackreply.php" method="POST"><input type="hidden" name="feedback" value="' . $row['internalid'] . '"><button class="primary" type="submit">Respond</button></form></td></tr>';
				}
			?>
			</tbody>
		</table>
	</body>
</html>
