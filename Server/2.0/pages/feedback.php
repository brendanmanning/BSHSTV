<html>
	<head>
		<title>Give Feedback</title>
		<link rel="stylesheet" type="text/css" href="../mainstyle.css">
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/mu/0.3.0/mu.min.css" />
		<script src="../scripts/feedbackPage.js"></script>
	</head>
	<body>
		<center>
		<?php
			if(isset($_GET['success'])) {
				echo '<h1><p class="green">Thanks for the feedback! You can now exit Feedback!</p></h1>';
			}
			if(isset($_GET['error'])) {
				echo '<p class="red">Feedback not submitted! Please try again!</p>';
			}
		?>
		<h1>Give Feedback</h1>
		<i>Something we forgot to say? Something we could improve? Let us know here!</i>
		<hr>
	<form action="_feedback.php" method="POST" id="feedbackform">
		<div class="row">
			<div class="c g3">
				<input type="text" placeholder="Your name" name="name" class="most" value=<?php if(isset($_GET['name'])) { echo '"' . $_GET['name'] . '"'; } else { echo '""'; }?>required>
			</div>
			<div class="c g3">
				<input type="text" placeholder="Email (Optional)" class="most" id="email" value=<?php if(isset($_GET['email'])) { echo '"' . $_GET['email'] . '"'; } else { echo '""'; }?> name="email">
			</div>
			<div class="c g3">
				<label><input type="checkbox" name="reply" value="1" onchange="toggleCheckbox(this)">Allow a follow up response</label>
			</div>
		</div>
		<br>
		<textarea class="large" placeholder="Your Comment" name="comment" form="feedbackform" required><?php if(isset($_GET['comment'])) { echo $_GET['comment']; }?></textarea>
		<br><br>
		<button type="submit" class="primary most">Submit</button>
		<br><hr><p><font size="2">By clicking Submit (above), you agree to provide the owner(s) of this website with the information that you provide. You agree that it may be stored by the owner(s) of this website. Also, by checking "Allow a follow up response" you consent to recieving email communication from the owner(s) of this website (as they see fit) via the email address you provide. Furthermore you agreee that the information or ideas you submit may be used by the owner(s) of this website without attribution to you the creator.</font></p>
		</center>
	</form>
</body>
</html>