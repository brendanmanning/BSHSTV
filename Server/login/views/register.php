<?php
// show potential errors / feedback (from registration object)
if (isset($registration)) {
    if ($registration->errors) {
        foreach ($registration->errors as $error) {
            echo $error;
        }
    }
    if ($registration->messages) {
        foreach ($registration->messages as $message) {
       		if($message == "created") {
       	    		header("Location: index.php?registered");
       	    	} else {
           		echo $message;
           	}
        }
    }
}
?>
<?php
	require '../config.php';
	$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
	$sql = $conn->prepare("SELECT user_name,email FROM teachertokens WHERE token LIKE :tok");
	$sql->bindParam(":tok", $_GET['token']);


	$username = "";
	$email = "";
    	// Run the query and get the results
    	$sql->execute();
    	while($row=$sql->fetch()) {
    		$username = $row['user_name'];
    		$email = $row['email'];
    	}
    	
?>
<head>
	<title>Sign up</title>
	<link rel="stylesheet" href="../mainstyle.css">
</head>
<body class="loginback">
<!-- register form -->
<center><h2>Create an Account</h2></center>
<div class="login" style="height: 20em;">
<form method="post" action="register.php" name="registerform">
	<center>
	<br>
    <!-- the user name input field uses a HTML5 pattern check -->
    <!-- <label for="login_input_username">Pick a Username</label> -->

    <input id="login_input_username" placeholder="Pick a username" class="login_input most" type="text" pattern="[a-zA-Z0-9]{2,64}" name="user_name" value=<?php echo '"' . $username . '"'; if($username != "") { echo 'readOnly="readOnly"'; } ?> required />
	<br>
	<br>
    <!-- the email input field uses a HTML5 email type check -->
    <!-- <label for="login_input_email">User's email</label> -->
    <input id="login_input_email" placeholder="Your email" class="login_input most" type="email" name="user_email" value=<?php echo '"' . $email . '"'; if($email != "") { echo 'readOnly="readOnly"'; }?> required />
	<br>
	<br>
    <!-- <label for="login_input_password_new">Password (min. 6 characters)</label> -->
    <input id="login_input_password_new" class="login_input most" placeholder="Choose a Password" type="password" name="user_password_new" pattern=".{6,}" value=<?php if($username!="") { echo '"notrequired" readOnly="readOnly"'; } ?> required autocomplete="off" />
	<br>
	<br>
    <!-- <label for="login_input_password_repeat">Repeat password</label> -->
    <input id="login_input_password_repeat" placeholder="Same password again" class="login_input most" type="password" name="user_password_repeat" pattern=".{6,}" value=<?php if($username!="") { echo '"notrequired" readOnly="readOnly"'; } ?> required autocomplete="off" />
    
    <br>
    <br>
    <input type="hidden" name="token" value=<?php if(isset($_GET['token'])){echo '"' . $_GET['token'] . '"';} else { echo '""'; }?>>
    	
    <button type="submit" class="wide round primary"  name="register">Register</button>
</center>
</form>
</div>

</body>