<?php
class DefaultEnroller {
	private $userid = null;
	private $conn = null;
	private $clubsIn = null;
	private $defaultClubs = null;
	public function __construct($usr) {	
		$this->userid = $usr;
	}
	
	public function setConn($c) {
		$this->conn = $c;
	}
	
	public function enrollInDefaultClubs() {
		$defaultClubs = $this->defaultClubs();
		$clubsAlreadyIn = $this->clubsEnrolledIn();
		
		for($i = 0; $i < count($defaultClubs); $i++) {
			if(!in_array($defaultClubs[$i], $clubsAlreadIn)) {
				$this->enroll($defaultClubs[$i]);
			} 
		}
	}
	
	private function enroll($in) {
		$sql = $this->conn->prepare("INSERT INTO clubmembers (clubid, userid, name, active, notifications) VALUES (:cid, :uid, '[AutoEnrolled]', 1,1)");
		$sql->bindParam(":cid", $in);
		$sql->bindParam(":uid", $this->userid);
		$sql->execute();
	}
	
	private function defaultClubs() {
		$sql = $this->conn->prepare("SELECT clubid FROM defaultclubs");
		$sql->execute();
		
		$defaults = array();
		while($row=$sql->fetch()) {
			$defaults[] = $row['clubid'];
		}
		
		return $defaults;
	}
	
	private function clubsEnrolledIn() {
		$sql = $this->conn->prepare("SELECT clubid FROM clubmembers WHERE userid=:id");
		$sql->bindParam(":id", $this->userid);
		$sql->execute();
		
		$clubsIn = array();
		while($row=$sql->fetch()) {
			$clubsIn[] = $row['clubid'];
		}
		
		return $clubsIn;
	}
}
?>