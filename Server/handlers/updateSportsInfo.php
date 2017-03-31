<?php
	session_start();
	if(!isset($_POST['game']))
	{
		header("Location: ../wiz.php?step=" . $_SESSION['step']);
	} else if(!isset($_POST['time'])) {
		header("Location: ../wiz.php?step=" . $_SESSION['step']);
	} else if(!isset($_POST['location'])) {
		header("Location: ../wiz.php?step=" . $_SESSION['step']);
	} else {
		if($_SESSION['authed'] == true) {
			$_SESSION['game'] = $_POST['game'];
			$_SESSION['time'] = $_POST['time'];
			$_SESSION['location'] = $_POST['location'];
			$_SESSION['step'] = $_SESSION['step'] + 1;
		}
	}
	header("Location: ../wiz.php?step=" . $_SESSION['step']);
?>