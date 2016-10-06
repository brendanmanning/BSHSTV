<html>
	<head>
		<title>BSHS TV</title>
		<link rel="stylesheet" href="mainstyle.css">
		<link rel="stylesheet" href="mu.min.css">
		<script src="main.js"></script>
	</head>
	
	<body>
	
	<?php
		if(isset($_GET['success'])) {
			echo '<script>alert("Success"); window.location = "index.php";</script>';
		}
		
		if(isset($_GET['error'])) {
			echo '<script>alert("An error occured. Please try again later."); window.location = "index.php";</script>';
		}
	?>
		<center>
			<h2>BSHS TV</h2>
			<i>Stay up to date on all Channel 2 news, participate in community polls, and more! Forget what date that meeting was? Check BSHS TV! We've got the answer! Download the app today! It's FREE</i>
			<hr>
			<strong><a onclick="showFeatures()">Features</a></strong> | <strong><a onclick="showScreenshots()">Screenshots</a></strong> | <strong><a onclick="showContactForm()">Contact Support</a></strong>
			<div id="featuresDiv" style="visibility: hidden;height:0px;">
				<ul>
					<strong>1.</strong> In app videos<br>
					<strong>2.</strong> List of current announcements. Add them to your calendar, Get a notification before and share them as you please!<br>
					<strong>3.</strong> Tells what sports games are happening on any given day</strong><br>
					<strong>4.</strong> Banner show snow days, late arrivals etc* <br><i>* Accuracy of provided information is not guarenteed nor official information from Bishop Shanahan High School </i>
				</ul>
			</div>
			<div id="screenshotsDiv" style="visibility: hidden; height: 0px;">
				<img src="img/HomeP.png" class="screenshot portrait"></img>
				<img src="img/EventsP.png" class="screenshot portrait"></img>
				
				<br>
				<img src="img/HomeL.png" class="screenshot landscape"></img>
				<img src="img/EventsL.png" class="screenshot landscape"></img>
			</div>
			<div id="contactDiv" style="visibility: hidden; height: 0px;">
				<h4>Contact Support</h4>
				<form action="doContact.php" method="POST">
					<strong>What is your name?</strong><input type="text" name="name" placeholder="Your name here..." required>
					<br><br>
					<strong>What is your email?</strong><input type="email" name="email" placeholder="Your email here..." required>
					<br><br>
					<strong>Let us know what's wrong</strong><input type="text" name="short" placeholder="Describe your problem here" required>
					<br><br>
					<strong>Just read the box :)</strong><input type="text" name="extra" placeholder="Anything else you'd like us to know?" required>
					<br><br>
					<button type="submit" class="primary outline">Contact Support</button>
					<br><br>
					<i>By clicking "Contact Support" you consent to providing the above information and allow it to be used to contact you if the admin(s) of this site deem the situation merits it</i>
				</form>
			</div>
		</center>
	</body>
</html>