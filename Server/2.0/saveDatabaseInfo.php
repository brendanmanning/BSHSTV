<?php
		session_start();
		
		if($_SESSION['authed'])
		{} else {
			header("Location: wizard.php");
			die("You were not authed. Redirecting to login page...");
		}

		include 'config.php';
		
		$errors = 0;
		$operations = 0;
		$skipped = 0;
		
		$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name , $user, $pass);
	
		// set the PDO error mode to exception
    		$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    		
    		$sql = $conn->prepare("UPDATE `banner` SET `bannerText` = :banner WHERE `internalid` = 1;");
    		$sql->bindParam(':banner', $_SESSION['banner']);
    		if($_SESSION['banner'] == null) {
    			$_SESSION['banner'] = "";
    		}
    			if($sql->execute())
    			{
    			} else {
    				$errors += 1;
    			}
    			
    			$operations += 1;
    		/* Drop today's row just in case */
    		$date = date("m-d-Y");
    		
    		$sql = $conn->prepare("DELETE FROM `today` WHERE `date` LIKE :d");
    		$sql->bindParam(':d', $date);
		if($sql->execute())
		{
			echo "dropped ok";
		}
    		
    		/* With any rows for today gone we can now add one */
    		$sql = $conn->prepare("INSERT INTO `today` (`internalid`, `date`, `song`, `artist`, `bell`, `game`, `time`, `at`) VALUES (NULL, :d, :song, :artist, 1, :game, :time, :location)");
    		$sql->bindParam(':d', $date);
    		
    		// Bind SQL Params
    		if($_SESSION['song'] == null || $_SESSION['song'] == "")
    		{
    			$sql->bindParam(':song', "No Song");
    		} else {
    			$sql->bindParam(':song', $_SESSION['song']);
    		}
    		
    		if($_SESSION['artist'] == null || $_SESSION['artist'] == "")
    		{
    			$sql->bindParam(':artist', "Unknown Artist");
    		} else {
    			$sql->bindParam(':artist', $_SESSION['artist']);
    		}
    		
    		
    		/* 
    		   Because of PHP's rules, you can't pass an empty string "" as a method argument
    		   for bindParam(). So i made a variable that contains an empty string as passed that 
    		*/
    		$empty = "";
    		
    		if($_SESSION['game'] == null)
    		{
    			// iOS app handles blank games gracefully
    			$sql->bindParam(':game', $empty);
    		} else {
    			$sql->bindParam(':game', $_SESSION['game']);
    		}
    		
    		if($_SESSION['time'] == null)
    		{
    			// iOS app handles blank games gracefully
    			$sql->bindParam(':time', $empty);
    		} else {
    			$sql->bindParam(':time', $_SESSION['time']);
    		}
    		
    		if(isset($_SESSION['location']) == false)
    		{
    			// iOS app handles blank games gracefully
    			$sql->bindParam(':location', $empty);
    		} else {
    			$sql->bindParam(':location', $_SESSION['location']);
    		}
    		
    		try {
    			$sql->execute();
  		} catch (PDOException $e) {
  			echo $e->getMessage();
    			$errors += 1;
    		}
    		
    		$operations += 1;
    		
    		echo "<h1>Some errors occured</h1>";
    		echo "<br>Skipped: " . $skipped;
    		echo "<br>Errors: " . $errors;
    		echo "<br>Total Operations: " . $operations;
    		if($errors == 0) {
    			header("Location: wiz.php?step=end");
    		} else {
    			echo "<br><i>Information regarding errors is above. <br><a href='handlers/resetData.php'>Try resetting your session data (all progress will be lost)</a><br>If there were no errors and the redirect failed, <a href='wiz.php?nextsteps'>click here</a>";
    		}
   ?>