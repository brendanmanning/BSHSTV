<?php
  // Include database constants (ofc)
  require 'config.php';

  // Make sure all the fields were filled
  if(!isset($_POST['name']) || !isset($_POST['songname']) || !isset($_POST['songartist'])) {
    header("Location: requestsong.php?name=" . (isset($_POST['name'])) ? $_POST['name'] : "" . "&songname=" . (isset($_POST['songname'])) ? $_POST['songname'] : "" . "&artist" . (isset($_POST['songartist'])) ? $_POST['songartist'] : "" . "&album" . (isset($_POST['album'])) ? $_POST['album'] : "");
    exit(0);
  }

  // Prepare the database connection
  $conn = new PDO("mysql:host=" . $host . ";dbname=" . $name,$user,$pass);
	$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

  // Prepare the SQL query
  $sql = $conn->prepare("INSERT INTO songs (title, artist, album, requester) VALUES (:song, :artist, :album, :name)");

  // Bind values from post
  $sql->bindParam(":song", $_POST['songname']);
  $sql->bindParam(":artist", $_POST['songartist']);
  $sql->bindParam(":album", (isset($_POST['album'])) ? $_POST['album'] : "");
  $sql->bindParam(":name", $_POST['name']);

  if($sql->execute()) {
    header("Location: requestsong.php?ok");
  } else {
    header("Location: requestsong.php?error");
  }
?>
