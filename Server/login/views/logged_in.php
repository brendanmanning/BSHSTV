<?php
	session_start();
	if(!$_SESSION['authed']) {
		/*if($_SESSION['app_login'] == true) {
			echo "<a href='bshstv://action=settoken?[" . $_SESSION['token'] . "]'>Open in app</a>";
		} else {*/
			header("Location: ../tcadmin.php"); 
		//}
	} else {
		header("Location: ../index.php");
	}
?>
