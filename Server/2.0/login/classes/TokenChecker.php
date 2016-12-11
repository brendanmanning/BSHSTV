<?php	
class TokenChecker {
	private $conn = null;
	private $sql = null;
	private $token = null;
	private $username = null;
	private $userid = null;
	public function __construct() {
		// Get database constants
		require '../config.php';
		// Create a PDO connection
		$conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
		$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		
		$this->conn = $conn;
	}
	
	public function setToken($t) {
		$this->token = $t;
	}
	
	public function setUsername($n) {
		$this->username = $n;
	}
	
	public function setUserID($i) {
		$this->userid = $i;
	}
	
	public function tokenValid() {
		// Prepare SQL query
		if($this->userid == null) {
			$this->sql = $this->conn->prepare("SELECT active FROM tokens WHERE user_name LIKE :uname AND token LIKE :token");
			$this->sql->bindParam(":uname", $this->username);
		} else {
			$this->sql = $this->conn->prepare("SELECT active FROM tokens WHERE userid=:id AND token LIKE :token");
			$this->sql->bindParam(":id", $this->userid);
		}
		// Bind the parameters to the SQL query and execute
		$this->sql->bindParam(":token", $this->token);
		
		// Execute and iterate over the results
		$this->sql->execute();
		while($row=$this->sql->fetch()) {
			if($row['active'] == 1) { return true; }
		}
		
		return false;
	}
}
?>