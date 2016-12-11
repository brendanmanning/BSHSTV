<?php
class PushNotification {
	
	private $device = null;
	private $title = null;
	private $body = null;
	private $fcm_key = null;
	private $notifications = true;
	private $userid = null;
	private $conn = null;
	private $type = "club";
	public function __construct() {
		require_once 'config.php';
		
		$this->fcm_key = "AAAAVShokgY:APA91bEoHOmvc6ljs9ilGztqzvO-zn_xu8siy_fOu2vcYhb7FPO2hfpJHO89m2Cw3vcU-CokQOVERKmvlmdDSOb7DOJt2umxwUqRCeQzGO7x249rPe4V4HiQJQkBgwk8gxRJaVDx1B6kORClKwJTgMA68omcFaS-Xw";
	}
	
	public function setConn($c) {
		$this->conn = $c;
	}
	
	public function setUserID($userid) {
		$this->userid = $userid;
	}
	
	public function setTitle($t) {
		$this->title = $t;
	}
	
	public function setMessage($b) {
		$this->body = $b;
	}
	
	public function send() {
		$this->device = $this->getFCMID();
		if($this->device != null) {
			return $this->sendToFCMID();
		}
		
		return false;
	}
	
	private function getFCMID() {
		$sql = $this->conn->prepare("SELECT fcmid FROM fcmids WHERE userid=:user");
		$sql->bindParam(":user", $this->userid);
		$sql->execute();
		// It's possible that multiple rows will exist,
		// however because userids are unique to each
		// device, we'll never have to worry about dealing
		// with multiple rows, so just return the first one
		while($row=$sql->fetch()) {
			return $row['fcmid'];
		}
		
		return null;
	}
	
	private function sendToFCMID() {
		$ch = curl_init("https://fcm.googleapis.com/fcm/send");
		
		//Creating the notification array.
   		$notification = array('title' =>$this->title , 'text' => $this->body);

		// Add data to this notification
		$keyDataPairs = array('data' => array('__type' => $this->type, '__url' => "clubs/{club}/meetings/15"));

   	 	//This array contains, the token and the notification. The 'to' attribute stores the token.
  		$arrayToSend = array('to' => $this->device, 'notification' => $notification, 'data' => $keyDataPairs, 'priority'=>'high');

    		//Generating JSON encoded string form the above array.
    		$json = json_encode($arrayToSend);
    		
    		//Setup headers:
  		$headers = array();
    		$headers[] = 'Content-Type: application/json';
    		$headers[] = 'Authorization: key=' . $this->fcm_key; // key here

    		//Setup curl, add headers and post parameters.
    		curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");                                                                     
    		curl_setopt($ch, CURLOPT_POSTFIELDS, $json);
    		curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);       
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
    		//Send the request
    		$response = curl_exec($ch);

    		//Close request
    		curl_close($ch);
    		
    		$json = json_decode($response);
    		foreach ($json as $k => $v) {
    			if($k == "success") {
    				return $v == 1;
    			}
    		}
    		
    		return false;
	}
}
?>