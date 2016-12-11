<html>
  <head>
    <title>Request a Song</title>
    <link rel="stylesheet" href="mainstyle.css">
  </head>
  <body>
    <?php
      if(isset($_GET['ok'])) {
        echo '<p class="green">Song Requested! Thanks!</p>';
      }

      if(isset($_GET['error'])) {
        echo '<p class="red">Error requesting. It\'s not your fault. Please try again later.</p>';
      }
     ?>
    <h1>Request a song</h1>
    <p><i>If you ask nicely, we might play it on Channel 2!</i> 😉</p>
    <hr>
    <form action="requestsonghandler.php" method="POST">
      <div class="row">
        <div class="c g2">
          <label for="songname">Song Name</label>
          <input type="text" name="songname" id="songname" placeholder="Hey Jude"  value="<?php echo (isset($_GET['songname'])) ? $_GET['songname'] : ''; ?>" required>
          <br>
        </div>
        <div class="c g2">
          <label for="songartist">Artist</label>
          <input type="text" name="songartist" id="songartist" placeholder="The Beatles" class=""  value="<?php echo (isset($_GET['artist'])) ? $_GET['artist'] : ''; ?>" required>
          <br>
        </div>
      </div>
      <br>
      <div class="row">
        <div class="c g2">
          <label for="album">Album (optional)</label>
          <input type="text" name="album" id="album" placeholder="Hit Single" class=""  value="<?php echo (isset($_GET['album'])) ? $_GET['album'] : ''; ?>" >
        </div>
        <div class="c g2">
          <label for="yourname">Your Name</label>
          <input type="text" name="name" id="yourname" placeholder="John Doe" class=""  value="<?php echo (isset($_GET['name'])) ? $_GET['name'] : ''; ?>" required>
        </div>
      </div>
      <br>
      <button class="primary round wide" type="submit">Request</button>
    </form>
  </body>
</html>
