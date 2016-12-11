<?php
class UserGetter {

	private $userid = null;
	private $conn = null;
	
	public function __construct($user) {
		$this->userid = $user;
		require 'config.php';
		$this->conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
	}
	
	public function userExists() {
		$sql = $this->conn->prepare("SELECT user_id FROM users WHERE user_name LIKE :name");
		$sql->bindParam(":name", $this->userid);
		$sql->execute();
		while($row=$sql->fetch()) {
			return true;
		}
		
		return false;
	}
	
	public function userEmail() {
		$sql = $this->conn->prepare("SELECT user_email FROM users WHERE user_name LIKE :name");
		$sql->bindParam(":name", $this->userid);
		$sql->execute();
		while($row=$sql->fetch()) {
			return $row['user_email'];
		}
		
		return null;
	}
	
	public function clubs() {
		$clubs = array();
		$sql = $this->conn->prepare("SELECT internalid FROM clubs WHERE admin LIKE :name");
		$sql->bindParam(":name", $this->userid);
		$sql->execute();
		while($row=$sql->fetch()) {
			$clubs[] = $row['internalid'];
		}
		
		return $clubs;
	}
}
?>