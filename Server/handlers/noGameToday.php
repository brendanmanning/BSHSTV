<?php
	session_start();
	if($_SESSION['authed']) {
		$_SESSION['step'] = $_SESSION['step'] + 1;
		$_SESSION['game'] = "";
		$_SESSION['time'] = "";
		$_SESSION['location'] = "";
		header("Location: ../wiz.php?step=" . $_SESSION['step']);
	} else {
		header("Location: ../wizard.php?login");
	}
?>