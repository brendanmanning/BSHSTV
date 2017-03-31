<?php
		include 'auth.php';		
		include 'config.php';
		if(!isset($_POST['url'])) {
			header("addvideo.php");
			exit(-1);
		}
		$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name , $user, $pass);
	
		// set the PDO error mode to exception
    		$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    		
    		$sql = $conn->prepare("INSERT INTO videos (id) VALUES(:id)");
    		$sql->bindParam(':id', getVideoID($_POST['url']));
    		$sql->execute();
    		
    		
    		function getVideoID($url)
    		{
    			$url = str_replace("www.","",$url);
    			$url = str_replace("https://", "",$url);
    			$url = str_replace("http://", "", $url);
    			if(startsWith($url,"youtube.com/watch?v="))
    			{
    				$url = str_replace("youtube.com/watch?v=", "",$url);
    				if(strlen($url) == 11)
    				{
    					if(isStringValid($url))
    					{
    						return $url;
    					}
    				}
    				
    				die("Error");
    			} else if(startsWith($url,"youtu.be/")) {
    				$url = str_replace("youtu.be/", "", $url);
    				if(strlen($url) == 11)
    				{
    					if(isStringValid($url))
    					{
    						return $url;
    					}
    				}
    				
    				die("Error");
    			} else {
    				die("Error");
    			}
    		}
    		
    		function startsWith($haystack, $needle) {
    			// search backwards starting from haystack length characters from the end
    			return $needle === "" || strrpos($haystack, $needle, -strlen($haystack)) !== false;
		}
		
		function isStringValid($string)
		{
			$valid = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_";
			for($i = 0; $i < strlen($url); $i++)
			{
				if((strpos($valid, $string[$i]) !== false))
				{
				
				} else {
					return false;
					} 
			}
			
			return true;
		}
?>