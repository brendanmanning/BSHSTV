<?php
	session_start();
	
	if($_SESSION['authed'])
	{
		$_SESSION['banner'] = $_POST['banner'];
		$_SESSION['step'] = $_SESSION['step'] + 1;
		header("Location: ../wiz.php?step=" . $_SESSION['step']);
	} else {
		header("Location: ../wizard.php");
	}
?>