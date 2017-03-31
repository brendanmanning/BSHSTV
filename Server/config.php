<?php
	/* Database Connection Settings */
	//
	// Database host (usuallu localhost)
	$host = "localhost";
	// A MySQL user (NEVER root) with all permissions on the database
	$user = "brenuzrr_bshstv";
	// Database Password
	// Password belonging to MySQL user account above
	$pass = "[Pvr.AQ]T,@x";
	// The actual MySQL database you setup
	$name = "brenuzrr_bshstv";

	/* Admin Account Settings */
	//
	// Password to login as overall admin
	$password = "tvstudio";

	/* Basic Site Settings */
	//
	// Site URL (Where your website can be reached)
	// Example: $url = "http://www.example.com/app/";
	// MUST END IN A SLASH ( / )
	$url = "http://apps.brendanmanning.com/bshstv/";

	/* Email Settings */
	//
	// Server email
	// This is the address PHP will emails to users from
	// It does not have to be your server's default email address
	// but it should be an address on this web server. If your mail
	// settings are configured improperly, some email providers (Gmail)
	// might reject or flag your emails
	$server_email = "noreply@example.com";
	//
	// Admin email
	// All emails regarding site activity (ex. A new club is requested)
	// will be sent to this email. Since we're sending the email to ourself,
	// no unsubscribe link will be included. If you don't want to recieve emails,
	// set a dummy account here
	$admin_email = "example@example.com";
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

	/* Push Notification Settings */
	//
	// Enable/Disable firebase notifications
	// For information on iOS notifications, go to
	// firebase.google.com
	$push_notifications_enabled = true;
	//
	// Cloud messaging token from Firebase
	// This is going to be a VERY long alpha-numeric-special string
	$push_notification_token = "Firebase String here";

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
