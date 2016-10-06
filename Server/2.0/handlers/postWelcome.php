<?php
	session_start();
	if($_SESSION['authed']) {
		header("Location: ../wiz.php?step=" . $_SESSION['step']);
	} else {
		header("Location: ../wizard.php?login");
	}
?>