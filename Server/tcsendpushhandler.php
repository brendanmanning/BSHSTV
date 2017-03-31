<?php
	// Get the libraries & configs we need
	require 'whichauth.php';
	require 'ClubPusher.php';
	
	// Redirect users that aren't authed
	if(which() != 2) { header("Location: login/index.php"); }
	
	// Make sure all input is filled
	if(!isset($_POST['title']) || !isset($_POST['message']) || !isset($_POST['club'])) { header("Location: tcsendpush.php?incomplete"); }

	
	// Send using out handy library
	$pusher = new ClubPusher();
	$pusher->setClub($_POST['club']);
	$pusher->setTitle($_POST['title']);
	$pusher->setMessage($_POST['message']);
	$pusher->send();
?>
	
	