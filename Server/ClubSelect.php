<?php
class ClubSelect {
	private $conn = null;
	public function __construct() {
		require_once 'config.php';
	
		$this->conn = new PDO("mysql:host=" . $host . ";dbname=" . $name , $user, $pass);
	
		// set the PDO error mode to exception
    		$this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    		
	}
	
	public function forCurrentUser() {
		// Prepare the arrays to save club information
    		$clubs = array();
    		$ids = array();
    	
    		// Save information about the user
    		$name = $_SESSION['user_name'];

    		// Prepare a SQL query to get every club this user oversees
    		$sql = $this->conn->prepare("SELECT internalid, title FROM clubs WHERE admin LIKE :username");
    		$sql->bindParam(":username", $name);

    		// Run the query and get the results
    		$sql->execute();
    		while($row=$sql->fetch()) {
    			$clubs[] = $row['title'];
    			$ids[] = $row['internalid'];
    		}
    	
    		// Prepare an HTML select tag from this data 
    		$clubSelect = "<select name='club'>";
    		for($i = 0; $i < count($clubs); $i++) {
    			$clubSelect .= "<option value='" . $ids[$i] . "'>" . $clubs[$i] . "</option>";
    		}
    		$clubSelect .= "</select>";
    		
    		return $clubSelect;
	}
}