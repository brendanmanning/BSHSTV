<!--
    This file was obtained from W3Schools
    To view the tutorial, please visit
    http://www.w3schools.com/php/php_file_upload.asp
-->
<?php
// Require config.php for file type validation
require 'config.php';

// Validate input
if(!isset($_POST['ul_path']) || !isset($_POST['sender'])) {
  echo "Input missing";
  $uploadOk = 0;
}

switch($_POST['ul_path']) {
  case "img/":
    $target_dir = "img/";
    break;
  case "songs/":
    $target_dir = "songs/";
    break;
  default:
    echo "That directory is not valid";
    $uploadOk = 0;
    break;
}
$target_file = $target_dir . preg_replace("/[^A-Za-z0-9.]/", "_", basename($_FILES["fileToUpload"]["name"]));
$uploadOk = 1;
$imageFileType = pathinfo($target_file,PATHINFO_EXTENSION);
// Check if image file is a actual image or fake image
$file_info = new finfo(FILEINFO_MIME);	// object oriented approach!
$mime_type = $file_info->buffer(file_get_contents($_FILES["fileToUpload"]["tmp_name"]));

if(!in_array(explode("/", $mime_type)[0], $allowed_file_types)) {
  echo "That file type is not supported. (Debugging: File type = " . $mime_type . ") <br>";
  $uploadOk = 0;
}

// Check if file already exists
if (file_exists($target_file)) {
    echo "Sorry, file already exists.";
    $uploadOk = 0;
}
// Check file size
if ($_FILES["fileToUpload"]["size"] > 10000000) {
    echo "Sorry, your file is too large.";
    $uploadOk = 0;
}

// Check if $uploadOk is set to 0 by an error
if ($uploadOk == 0) {
    echo "Sorry, your file was not uploaded.";
// if everything is ok, try to upload file
} else {
    if (move_uploaded_file($_FILES["fileToUpload"]["tmp_name"], $target_file)) {
        header("Location: " . $_POST['sender'] . "?file=" . $target_file);
    } else {
        echo "Sorry, there was an error uploading your file.";
    }
}
?>
