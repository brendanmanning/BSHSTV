<?php
	session_start();
	/* Session variables we write to */
	/*
	 - song
	 - artist
	 - step
	 - authed
	 - game
	 - location
	 - time
	 - banner
	 */
	 if($_SESSION['authed'] == false) {
	 	die("Please authenticate first");
	 }
	 $_SESSION['song'] = null;
	 $_SESSION['artist'] = null;
	 $_SESSION['step'] = null;
	 $_SESSION['authed'] = false;
	 $_SESSION['game'] = "";
	 $_SESSION['location'] = "";
	 $_SESSION['time'] = null;
	 $_SESSION['banner'] = "";
	 
	 header("Location: ../wizard.php");
?>