<?php
	if((isset($_POST['name']) == false) || (isset($_POST['email']) == false) || (isset($_POST['short']) == false) || (isset($_POST['extra']) == false)) 
	{
		die("You left a field blank.");
	} else {
		require 'config.php';
		// Always set content-type when sending HTML email
		$headers = "MIME-Version: 1.0" . "\r\n";
		$headers .= "Content-type:text/html;charset=UTF-8" . "\r\n";
		//$headers .= 'From: <' . EMAIL . '>' . "\r\n";
		if(mail(EMAIL, "Support Requested by " . $_POST['name'], "Message: " . $_POST['short'] . "<br>Additional information: " . $_POST['extra'] . "<br>Email: <a href='mailto:" . $_POST['email'] . "'>" . $_POST['email'] . '</a>', $headers)) {
		
		if(mail($_POST['email'], "noreply: BSHS TV Support", "Hello! Thanks for requesting help with the BSHS TV app! We'll look into your issue and contact you if need be. Otherwise this will be the last email you recieve.", $headers)) {
			header("Location: index.php?success");
		} else {
			header("Location: index.php?error");
		}
			
		} else {
			header("Location: index.php?error");
		}
	}
?>