<?php
	session_start();
	if($_SESSION['authed'] == false)
	{
		header("Location: wizard.php?login&sender=http://$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]");
		exit(0);
	}
?>
