<!-- login form box -->
<head>
	<link rel="stylesheet" href="../mainstyle.css">
	<script>
		function submitForm() {
			document.getElementById("loginform").submit();
		}
	</script>
</head>
<center>
<body class="loginback" <?php if(isset($_GET['token']) && isset($_GET['userid'])) { echo 'onload="submitForm()"'; }?> >
<?php
// show potential errors / feedback (from login object)
if (isset($login)) {
    if ($login->errors) {
        foreach ($login->errors as $error) {
            echo $error;
        }
    }
    if ($login->messages) {
        foreach ($login->messages as $message) {
            echo $message;
        }
    }
}
?>
<?php
	if(isset($_GET['registered'])) {
		echo "<h2>Account Created! Now you can login!</h2>";
	}
?>
<div class="login">
<form method="post" action="index.php" name="loginform" id="loginform">
<br>
    <label for="login_input_username">Username</label>
    <input id="login_input_username" class="most" type="text" name="user_name" placeholder="Username/Email" required />
<br><br>
    <label for="login_input_password">Password</label>
    <input id="login_input_password" class="most" type="password" name="user_password" autocomplete="off" placeholder="Account password" required />
	<br><br>
    <button type="submit" class="primary round most" name="login">Log in</button>
    <?php if(isset($_GET['userid'])) { echo '
    	<input type="hidden" name="user_id" value="' . $_GET['userid'] . '">';
    	} ?>
    	
    <?php if(isset($_GET['token'])) { echo '
    	<input type="hidden" name="token" value="' . $_GET['token'] . '">';
    	} ?>

</form>
</center>
</div>
</div>