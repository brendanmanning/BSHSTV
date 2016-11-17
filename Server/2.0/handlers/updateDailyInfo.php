<?php
	require_once '../config.php';
	
	// We're saving all data in $_SESSION until the user is ready to confirm all changes
	session_start();
	
	if(!isset($_POST['song'])) { 
		die("You left the song field blank. Please go back and fix that.");
	}
	
	if(!isset($_POST['artist'])) { 
		die("You left the artist field blank. Please go back and fix that.");
	}
	$_SESSION['song'] = $_POST['song'];
	$_SESSION['artist']  = $_POST['artist'];
	$_SESSION['step'] = $_SESSION['step'] + 1;
	
	header("Location: ../wiz.php?step=" . $_SESSION['step']);
	
?>