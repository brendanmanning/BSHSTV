<?php
	$host = "{dbhost}";
	$user = "{dbuser}";
	$pass = "{dbpass}";
	$name = "{dbname}";

	$password = "{admin_pass}";

	$url = "{server_url}";

	/* Email Settings */
	//
	// Server email
	// This is the address PHP will emails to users from
	// It does not have to be your server's default email address
	// but it should be an address on this web server. If your mail
	// settings are configured improperly, some email providers (Gmail)
	// might reject or flag your emails
	$server_email = "{admin_email}";
	//
	// Admin email
	// All emails regarding site activity (ex. A new club is requested)
	// will be sent to this email. Since we're sending the email to ourself,
	// no unsubscribe link will be included. If you don't want to recieve emails,
	// set a dummy account here
	$admin_email = "you email";
	//
	// Blind Carbon Copy
	// Send a copy of feedback responses to yourself (at the $admin_email)
	$feedback_bcc = false;
	//
	// Club Request Notification
	// Get an email when a teacher requests a club
	$club_request_notification = true;

	/* User Input Restriction Settings */
	//
	// Valid file types
	// Sometimes teachers or admins have to upload files
	// Here you can enable or disable file types that the server will accept
	$images = true;
	$videos = false;
	$music = true;
	$text = false;
	$executables = false;

	/* Config handlers - DO NOT EDIT BELOW THIS LINE */
	// Some settings variables don't work right off the bat.
	// Here some extra work is done to make managing settings easier from
	// a programming standpoint
	$allowed_file_types = array();
	if($images) {
		$allowed_file_types[] = "image";
	}
	if($videos) {
		$allowed_file_types[] = "video";
	}
	if($music) {
		$allowed_file_types[] = "audio";
	}
	if($text) {
		$allowed_file_types[] = "text";
	}
	if($executables) {
		$allowed_file_types[] = "application";
	}
?>
