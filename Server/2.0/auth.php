<?php
	session_start();
	if($_SESSION['authed'] == false)
	{
		header("Location: wizard.php");
		exit(0);
	}
?>