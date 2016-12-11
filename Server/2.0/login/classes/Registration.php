<?php

/**
 * Class registration
 * handles the user registration
 */
class Registration
{
    /**
     * @var object $db_connection The database connection
     */
    private $db_connection = null;
    /**
     * @var array $errors Collection of error messages
     */
    public $errors = array();
    /**
     * @var array $messages Collection of success / neutral messages
     */
    public $messages = array();

    /**
     * the function "__construct()" automatically starts whenever an object of this class is created,
     * you know, when you do "$registration = new Registration();"
     */
    public function __construct()
    {
        if (isset($_POST["register"])) {
            $this->registerNewUser();
        }
    }

    /**
     * handles the entire registration process. checks all error possibilities
     * and creates a new user in the database if everything is fine
     */
    private function registerNewUser()
    {
        if (empty($_POST['user_name'])) {
            $this->errors[] = "Empty Username";
        } elseif (empty($_POST['user_password_new']) || empty($_POST['user_password_repeat'])) {
            $this->errors[] = "Empty Password";
        } elseif ($_POST['user_password_new'] !== $_POST['user_password_repeat']) {
            $this->errors[] = "Password and password repeat are not the same";
        } elseif (strlen($_POST['user_password_new']) < 6) {
            $this->errors[] = "Password has a minimum length of 6 characters";
        } elseif (strlen($_POST['user_name']) > 64 || strlen($_POST['user_name']) < 2) {
            $this->errors[] = "Username cannot be shorter than 2 or longer than 64 characters";
        } elseif (!preg_match('/^[a-z\d]{2,64}$/i', $_POST['user_name'])) {
            $this->errors[] = "Username does not fit the name scheme: only a-Z and numbers are allowed, 2 to 64 characters";
        } elseif (empty($_POST['user_email'])) {
            $this->errors[] = "Email cannot be empty";
        } elseif (strlen($_POST['user_email']) > 64) {
            $this->errors[] = "Email cannot be longer than 64 characters";
        } elseif (!filter_var($_POST['user_email'], FILTER_VALIDATE_EMAIL)) {
            $this->errors[] = "Your email address is not in a valid email format";
        } elseif (!empty($_POST['user_name'])
            && strlen($_POST['user_name']) <= 64
            && strlen($_POST['user_name']) >= 2
            && preg_match('/^[a-z\d]{2,64}$/i', $_POST['user_name'])
            && !empty($_POST['user_email'])
            && strlen($_POST['user_email']) <= 64
            && filter_var($_POST['user_email'], FILTER_VALIDATE_EMAIL)
            && !empty($_POST['user_password_new'])
            && !empty($_POST['user_password_repeat'])
            && ($_POST['user_password_new'] === $_POST['user_password_repeat'])
        ) {
            // create a database connection
            $this->db_connection = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);

            // change character set to utf8 and check it
            if (!$this->db_connection->set_charset("utf8")) {
                $this->errors[] = $this->db_connection->error;
            }

            // if no connection errors (= working database connection)
            if (!$this->db_connection->connect_errno) {

                // escaping, additionally removing everything that could be (html/javascript-) code
                $user_name = $this->db_connection->real_escape_string(strip_tags($_POST['user_name'], ENT_QUOTES));
                $user_email = $this->db_connection->real_escape_string(strip_tags($_POST['user_email'], ENT_QUOTES));

                $user_password = $_POST['user_password_new'];

                // crypt the user's password with PHP 5.5's password_hash() function, results in a 60 character
                // hash string. the PASSWORD_DEFAULT constant is defined by the PHP 5.5, or if you are using
                // PHP 5.3/5.4, by the password hashing compatibility library
                $user_password_hash = password_hash($user_password, PASSWORD_DEFAULT);

                // check if user or email address already exists
               /* $sql = "SELECT * FROM users WHERE user_name = '" . $user_name . "' OR user_email = '" . $user_email . "';";
                $query_check_user_name = $this->db_connection->query($sql);

                if ($query_check_user_name->num_rows == 1) {
                    $this->errors[] = "Sorry, that username / email address is already taken.";
                } else {
                */
                    // Ensure the user is trying to sign up with a valid teacher token
                    if(empty($_POST['token'])) {
                    	$this->errors[] = "Please use the link from your email";
                    }
                    
                    $token = $this->db_connection->real_escape_string(strip_tags($_POST['token'], ENT_QUOTES));
                    $result = $this->db_connection->query("SELECT * FROM `teachertokens` WHERE token LIKE '" . $token . "'");
                    
                    $rows = 0;
                    $clubId = -1;
                    $tokenId = -1;
                    $addToAccount = false;
                    $uname;
                    if($result->num_rows > 0) {
                    	while($row = $result->fetch_assoc()) {
                    		if($row['activated'] == 0) {
                    			$rows++;
                    			$clubId = $row['course'];
                    			$tokenId = $row['internalid'];
                    			
                    			if($row['user_name'] != "") { $addToAccount = true; $uname = $this->db_connection->real_escape_string(strip_tags($row['user_name']));}
                    		}
                    	}
                    }
                    
                    if($rows != 1) {
                    	$this->errors[] = "Your token is invalid. Make sure you came here using a correct link";
                    }
                    
                    if(($clubId != -1) && ($rows == 1)) {
                    	
                    	/* We have 3 SQL Query's top run */
                    	/* 1 - Create the new user record */
                    	/* 2 - Set the club's admin to this user_name, and activate the club */
                    	/* 3 - Update the teachertokens and set the active flag to 1 (so this can't be reused) */
                    	
                    	// Query #1
                    	if(!$addToAccount) {
                    		$sql = "SELECT * FROM users WHERE user_name = '" . $user_name . "' OR user_email = '" . $user_email . "';";
                		$query_check_user_name = $this->db_connection->query($sql);

               			 if ($query_check_user_name->num_rows == 1) {
                   			 $this->errors[] = "Sorry, that username / email address is already taken.";
                   		} else {
                    		$sql = "INSERT INTO users (user_name, user_password_hash, user_email) 
                    		VALUES('" . $user_name . "', '" . $user_password_hash . "', '" . $user_email . "');";
                    		$query_new_user_insert = $this->db_connection->query($sql);
                    		}
                    	} else {
                    		$sql = "SELECT * FROM users WHERE user_name LIKE '" . $uname . "'";
                    		
                    		$result = $this->db_connection->query($sql);
                    		$countOfUsers = 0;
                    		if($result->num_rows > 0) {
                    			while($row = $result->fetch_assoc()) {
                    				$countOfUsers++;
                    			}
                    		}
                    		
                    		if($countOfUsers != 1) {
                    			$this->errors[] = "You can't add this course to a user that doesn't exist";
                    		} else {
                    			$query_new_user_insert = true;
                    		}
                    	}
                    	$club_update = false;
                    	$token_update = false;
                    	
                    	if($query_new_user_insert) {
                    	// Query #2
                    	if(!$addToAccount) {
                    		$sql = "UPDATE clubs SET admin='" . $user_name . "', active=1 WHERE internalid=" . $clubId;
                    	} else {
                    		$sql = "UPDATE clubs SET admin='" . $uname . "', active=1 WHERE internalid=" . $clubId;
                    	}
			$club_update = $this->db_connection->query($sql);
			
			// Query #3
			$sql = "UPDATE teachertokens SET activated=1 WHERE internalid=" . $tokenId;
			$token_update = $this->db_connection->query($sql);
			}
			
                    	// if user has been added successfully
                    	if ($query_new_user_insert && $club_update && $token_update) {
                       		 $this->messages[] = "created"; // will trigger a redirect
                 	   } else {
                       		 $this->errors[] = "Sorry, your registration failed. Please go back and try again.";
                   	 }
                   }
                //}
            } else {
                $this->errors[] = "Sorry, no database connection.";
            }
        } else {
            $this->errors[] = "An unknown error occurred.";
        }
    }
}