<?php
	session_start();
	
	$totalPages = 3;	
	//echo "<center><strong>Progress " . ($_SESSION['step'] + 2) . "/3 [<a href='handlers/resetData.php'>RESET</a>] </strong></center>";
	echo "<center>[<a href='handlers/resetData.php'>RESET PROGRESS</a>]</center>";
	/*if(isset($_SESSION['step'])) {
		echo "<progress current='" . ($_SESSION['step'] + 2) . "' max='" . $totalPages . "'></progress>";
	} else {
		echo "<progress current='0' max='" . $totalPages . "'></progress>";
	}*/
?>