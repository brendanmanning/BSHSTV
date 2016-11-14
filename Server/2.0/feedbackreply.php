<html>
  <head>
    <title>Respond to Feedback</title>
    <link rel="stylesheet" type="text/css" href="mainstyle.css">
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/mu/0.3.0/mu.min.css" />
	</head>
  <body>
    <h4><a href="feedback.php"><- Go Back</a></h4>
<?php
  // Include database constants
  include 'config.php';
  $conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
  $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

  // Make sure the user is authed
  include 'auth.php';

  // Get data from POST
  $feedback = $_POST['feedback'];
  
  // Get this feedback's data
  $sql = $conn->prepare("SELECT * FROM feedback WHERE internalid=:intid");
  $sql->bindParam(":intid", $feedback);
  $sql->execute();

  // Loop through the results
  while($row=$sql->fetch()) {
    if($row['reply'] == 0) {
      echo '<strong>This user did not allow you to respond</strong>';
    } else {
      echo '<form action="submitFeedbackReply.php" method="POST" id="reply"><strong>To:</strong>' . $row['name'] . '<br><p><strong>They said: </strong>' . $row['feedback'] . '</p><strong>Your Response:</strong><br><textarea class="large" placeholder="Your Reply" name="response" form="reply" required></textarea><input type="hidden" name="feedback" value="' . $row['internalid'] . '"><br><br><center><button class="wide" type="submit">Send Response</button></center></form>';
    }
  }
?>
</body>
</html>
