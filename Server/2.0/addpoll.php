<html>
	<head>
		<title>Finish Wizard</title>
		<link rel="stylesheet" type="text/css" href="mainstyle.css">
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/mu/0.3.0/mu.min.css" />
	</head>
	
	<body>
		<center>
			<h2>Add a poll</h2>
			<hr>
			<form action="add-poll.php" method="POST">
				<input type="text" placeholder="Title" name="title" class="large wide">
				<br>
				<br>
				<input type="text" placeholder="Poll prompt...What you're asking users" name="prompt" class="wide">
				<br>
				<strong>
					<p class="green">Poll Choices</p>
				</strong>
				<div class="row">
					<div class="c g2">
						<input type="text" placeholder="Choice #1" name="c1" class="most">
					</div>
					<div class="c g2">
						<input type="text" placeholder="Choice #2" name="c2" class="most">
					</div>
				</div>
				<br>
				<div class="row">
					<div class="c g2">
						<input type="text" placeholder="Choice #3" name="c3" class="most">
					</div>
					<div class="c g2">
						<input type="text" placeholder="Choice #4" name="c4" class="most">
					</div>
				</div>
				<br>
				<strong>
					<p class="green">Finishing Touches</p>
				</strong>
				<br>
				<input type="text" placeholder="What club is this for?" name="creator" class="most">
				<br>
				<br>
				<button type="submit" class="primary large">Create poll</button>
			</form>
		</center>
	</body>
</html>
		
		