<?php

  // Require authentication library
  require 'whichauth.php';

  if(!which() > 0) {
    echo "Only logged in users can be here. ";
    echo "<a href='login/'>Teacher Login</a> | <a href='wizard.php'>Channel 2 Login></a>";
    exit(0);
  }

  if(isset($_GET['ul_path'])) {
    $path = $_GET['ul_path'];
    switch($path) {
      case "img":
        $path = "img/";
        break;
      case "songs":
        $path = "songs/";
        break;
      default:
        echo "You can't upload to that folder.";
        exit(0);
    }
  }

  if(!isset($path)) {
    echo "Missing a url parameter";
    exit(0);
  }

  if(!isset($_GET['sender'])) {
    echo "Missing a url parameter";
    exit(0);
  } else {
    $sender = $_GET['sender'];
  }

  $reason = (isset($_GET['reason'])) ? $_GET['reason'] : "";
?>
<head>
  <link rel="stylesheet" href="mainstyle.css">
  <script src="scripts/uploadHandler.js"></script>
</head>
<h1>Upload a File</h1>
<i><?php echo $reason; ?></i>
<form action="uploadFile.php" method="POST" enctype="multipart/form-data" id="upload_form">

    <input type="file" name="fileToUpload" class="primary" id="fileToUpload" onchange="fileOnChange()">
  <input type="hidden" name="ul_path" value="<?php echo $path; ?>">
  <input type="hidden" name="sender" value="<?php echo $sender; ?>">
</form>
