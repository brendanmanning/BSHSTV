<?php
   function send_email($to, $from, $subject, $body) {
      // Set the sender field to a custom value from config.php
      $headers = "From: " . $from . "\r\n";
      // Enable HTML email
      $headers .= "MIME-Version: 1.0" . "\r\n";
      $headers .= "Content-type:text/html;charset=UTF-8" . "\r\n";

      return mail($to,$subject,$body,$headers);
    }
?>
