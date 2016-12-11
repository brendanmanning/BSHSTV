<?php
class ClubPusher {
	
	private $conn = null;
	private $club = null;
	private $user = null;
	private $title = null;
	private $message = null;

	public function __construct() {
		require 'config.php';
		
		$con = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
		$con->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		
		$this->conn = $con;
	}
	
	public function setTitle($t) {
		$this->title = $t;
	}
	
	public function setMessage($m) {
		$this->message = $m;
	}
	
	public function setClub($c) {
		$this->club = $c;
	}
	
	public function send() {
		require_once 'PushNotification.php';
		$notification = new PushNotification();
		$notification->setTitle($this->title);
		$notification->setMessage($this->message);
		$notification->setConn($this->conn);
		foreach($this->getUserIDS() as $user) {
			$notification->setUserID($user);
			$notification->send();
		}
	}
	
	private function getUserIDS() {
		$ids = array();
	
		$sql = $this->conn->prepare("SELECT userid FROM clubmembers WHERE clubid=:clubid AND notifications=1");
		$sql->bindParam(":clubid", $this->club);
		$sql->execute();
		
		while($row=$sql->fetch()) {
			$ids[] = $row['userid'];
		}
		
		return $ids;
	}
}
?>