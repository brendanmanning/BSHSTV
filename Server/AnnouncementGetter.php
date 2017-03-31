<?php
class AnnouncementGetter {
	
	private $conn = null;
	
	public function __construct() {
		require_once 'config.php';
		$this->conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
	}
	
	public function forClub($clubid, $allowHidden) {
		$anns = array();
		$sql =  $this->conn->prepare("SELECT * FROM announcements WHERE clubid=:id");
		$sql->bindParam(":id", $clubid);
		$sql->execute();
		while($row=$sql->fetch()) {
			if($row['enabled'] == 1 || $allowHidden) {
				$anns[] = array("id" => $row['internalid'],
						"creator" => $row['creator'],
						"title" => $row['title'],
						"text" => $row['text'],
						"date" => $row['date'],
						"image" => $row['image'],
						"enabled" => $row['enabled']
						);
			}
		}
		
		return $anns;
	}
}
?>