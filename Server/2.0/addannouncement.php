<?php
	include 'auth.php';
?>
<html>
	<head>
		<title>Add Announcment</title>
		<link rel="stylesheet" type="text/css" href="mainstyle.css">
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/mu/0.3.0/mu.min.css" />
	</head>
	
	<body>
		<center>
		<?php
			if(isset($_GET['ok'])) {
				echo "<p class='green'>Successfully added " . $_GET['event'] . "</p>";
			}
			
			if(isset($_GET['error'])) {
				echo "<p class='red'>Error adding " . $_GET['event'] . "</p>";
			}
		?>
		<h2>Add an Announcement</h2>
		<i>Users will see this in the BSHS TV app</i>
		<hr>
		<form action="add-announcement.php" method="POST">
			<input type="text" placeholder="Title" class="large" name="title" value=<?php echo '"' . $_GET['title'] . '"';?> required>
			<br>
			<br>
			<input type="text" placeholder="Event text" class="most" name="text" value=<?php echo '"' . $_GET['text'] . '"';?> required>
			<br>
			<br>
			<input type="text" placeholder="Image URL" class="most" name="image" value=<?php echo '"' . $_GET['image'] . '"';?> required>
			<br>
			<br>
			<input type="text" placeholder="Club" class="most" name="creator" value=<?php echo '"' . $_GET['creator'] . '"';?> required>
			<br>
			<br>
			<div class="row">
				<div class="c g3">
					<input type="text" placeholder="Month" name="m" class="most" required>
				</div>
				<div class="c g3">
					<input type="text" placeholder="Day" name="d" class="most" required>
				</div>
				<div class="c g3">
					<input type="text" placeholder="Year" name="y" class="most" required>
				</div>
			</div>
			<br>
			<div class="row">
				<div class="c g3">
					<input type="text" placeholder="Hour" name="hr" class="most" required>
				</div>
				<div class="c g3">
					<input type="text" placeholder="Minute" name="min" class="most" required>
				</div>
				<div class="c g3">
					<input type="text" placeholder="AM/PM" name="ampm" class="most" required>
				</div>
			</div>
			<br>
			<br>
			<p class="green">Override Attendee Function</p>
			<i>The Channel 2 Events section lets peole quickly say what events theyre going to. If an announcement isnt really something you can attend, you can disable that feature here.</i>
			<br>
		</center>
			<input type="radio" name="minvisitors" value="yes" checked>Allow Attendee Function<br>
			<input type="radio" name="minvisitors" value="no">Hide function<br>
		<center>
			<br>
			<button type="submit" class="primary">Submit</button>
		</form>
	</body>
</html>
