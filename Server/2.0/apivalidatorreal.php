<?php
	class APIValidator {
	 function check($conn) {
	 	if(isset($_GET['key']) == false || isset($_GET['secret']) == false) { return false; }
	 
		$sql = $conn->prepare("SELECT secret,maxcalls,calls FROM apikeys WHERE apikey LIKE :apiKey");
		$sql->bindParam(':apiKey',$_GET['key']);
		$sql->execute();
		while($row=$sql->fetch()) {
			
				
				if($row['secret'] == $_GET['secret'])
				{
					if(($row['calls'] > $row['maxcalls']) && ($row['maxcalls'] != -1))
					{return false; } else {
						// The API key is valid and is not over the limit
						$sql = $conn->prepare("UPDATE apikeys SET calls=calls+1 WHERE apikey LIKE :api_key");
						$sql->bindParam(":api_key",$_GET['key']);
						$sql->execute();
						return true;
						
					}
				}
			
		}
		return false;
	}
	}
?>
						