<?php
	//include 'config.php';
	function callUrlForKey($k,$s,$host,$name,$user,$pass)
	{
	//echo $k . "," . $s;
	//try {
		$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
		$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		$sql = $conn->prepare("SELECT secret,maxcalls,calls FROM apikeys WHERE apikey LIKE :apiKey");
		$sql->bindParam(':apiKey',$k);
		$sql->execute();
		while($row=$sql->fetch()) {
			
				
				if($row['secret'] == $s)
				{
					if(($row['calls'] > $row['maxcalls']) && ($row['maxcalls'] != -1))
					{return false; } else {
						// The API key is valid and is not over the limit
						$sql = $conn->prepare("UPDATE apikeys SET calls=calls+1 WHERE apikey LIKE :api_key");
						$sql->bindParam(":api_key",$k);
						$sql->execute();
						return true;
						
					}
				}
			
		}
		return false;
	/* catch (PDOException $e) {
	die($e->errorMessage());
		return false;
	}*/
	}
	
	function call($k,$s,$h,$n,$u,$p)
	{
		return callUrlForKey($k,$s,$h,$n,$u,$p);
	}
?>
						