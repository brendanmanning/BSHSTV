<?php
class NotificationPreference {
	
	private $conn = null;
	private $club = null;
	private $user = null;
	private $status = 0;
	
	public function __construct() {
		require_once "config.php";
		
		$this->conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
		$this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	}
	
	public function setClub($c) {
		$this->club = $c;
	}
	
	public function setUser($u) {
		$this->user = $u;
	}
	
	public function subscribe() {
		$this->status = 1;
		return $this->save();
	}
	
	public function ubsubscribe() {
		$this->status = 0;
		return $this->save();
	}
	
	private function save() {
		$sql = $this->conn->prepare("UPDATE clubmembers SET notifications=:pref WHERE userid=:userid");
		$sql->bindParam(":pref", $this->status);
		$sql->bindParam(":userid", $this->user);
		return $sql->execute();
	}
}