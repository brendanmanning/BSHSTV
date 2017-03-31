<?php
	session_start();
	function which() {
	
	
	if(!isset($_SESSION['authed'])) {
		if(!isset($_SESSION['user_login_status'])) {
			return 0;
		} else {
			if($_SESSION['user_login_status'] == 1) {
				return 2;
			}
		}
	} else {
		if(isset($_SESSION['user_login_status'])) {
			if($_SESSION['user_login_status'] == 1) {
				if($_SESSION['authed']) { return 2; }
				return 2;
			}
		}
		if($_SESSION['authed']) {
			return 1;
		}
	}
	
	return 0;
	}
	/*
		if($_SESSION['authed'] && ($_SESSION['user_login_status'] == 1)) {
			/* User is logged in as both a Channel 2 admin and a teacher (????)
	Tell them to log out of one or both bc it's rly late, I'm tired and it's too late to deal with this 
			return -1;
		} else if($_SESSION['authed']) {
			/* The user is logged in as a Channel 2 admin 
			return 1;
		} else if($_SESSION['user_login_status'] == 1) {
			/* The user is logged in as a teacher (using login/ folder) 
			return 2;
		} else {
			/* The user is not logged in 
			return 0;
		}
	}
	*/
?>