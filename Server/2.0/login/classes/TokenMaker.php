<?php
class TokenMaker
{
    private $conn = null;
    private $sql = null;
    private $token = null;
    private $username = null;
    private $deviceid = null;
    public function __construct()
    {
        // Get database constants
        require '../config.php';
        // Create a PDO connection
        $this->conn = new PDO("mysql:host=" . $host . ";dbname=" . $name, $user, $pass);
        $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    }
    
    private function genToken()
    {
        require '../Random.php';
        $tok   = null;
        $loops = 0;
        $ok    = false;
        while ($loops < 20) { // Timeout at 20 loops
            $tok = rand_str(15);
            if (!$this->tokenInDB($tok)) {
                $ok = true;
                break;
            }
            $loops++;
        }
        if (!$ok) {
            die("Well something is really messed up if you're seeing this");
        }
        return $tok;
    }
    
    private function tokenInDB($tok)
    {
        $newsql = $this->conn->prepare("SELECT * FROM tokens WHERE token LIKE :tok");
        $newsql->bindParam(":tok", $tok);
        $newsql->execute();
        while ($row = $newsql->fetch()) {
            return true;
        }
        
        return false;
    }
    
    public function setUsername($n)
    {
        $this->username = $n;
    }
    
    public function setUserID($id)
    {
        $this->deviceid = $id;
    }
    
    public function addAndReturnToken()
    {
        // Prepare SQL query
        $this->sql = $this->conn->prepare("INSERT INTO tokens (userid, user_name, token) VALUES (:deviceid, :username, :token)");
        $token = $this->genToken();
        $this->sql->bindParam(":deviceid", $this->deviceid);
        $this->sql->bindParam(":username", $this->username);
        $this->sql->bindParam(":token", $token);
        $this->sql->execute();
        return $token;
    }
}
?>