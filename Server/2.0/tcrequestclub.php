<html>
  <head>
    <title>Request a Club</title>
    <link rel="stylesheet" type="text/css" href="mainstyle.css">
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/mu/0.3.0/mu.min.css" />
    <script src="scripts/tcrequest.js"></script>
	</head>

  <body>
    <?php
      if(isset($_GET['error'])) {
        echo '<p class="red">Oops! Something went wrong. <strong>Please try again</strong></p>';
      }
    ?>
    <h1>Request a Club</h1>
    <i><strong>Teachers</strong>, fill out the form below to have your club use the Channel 2 (BSHS TV) app! Instructions to complete setup will be emailed to you once we approve your request Features include:
      <ul>
        <li>A simple, easy to use teacher website</li>
        <li>Sending announcements using an app students already use</li>
        <li>Restrict who can join using club passwords</li>
        <li>Also, remove specific users from your club at any time</li>
        <li>Manage multiple clubs in the same place (Coming Soon!)</li>
        <li>So much more....</li>
      </ul>
    </i>
    <hr>

    <form action="tcrequestclubhandler.php" method="POST">
      <center><strong><p class="green">Personal Info</p></strong></center>
      <div class="row">
        <div class="c g2">
          <label for="email">Your email address</label>
          <input type="email" name="email" id="email" placeholder="The one you will login in with" class="most" required>
        </div>
        <div class="c g2">
          <label for="name">Your name (full or with title)</label>
          <input type="text" name="name" id="name" placeholder="John Doe" class="most" required>
        </div>
      </div>
      <center><strong><p class="green">Let's Get to Known Your Club</p></strong></center>
      <div class="row">
        <div class="c g2">
          <label for="clubname">Name of Club</label>
          <input type="text" name="clubname" id="clubname" placeholder="ex. Channel 2, World Affairs Club" required>
        </div>
        <div class="c g2">
          <label for="clubpassword">Join Code</label>
          <input type="text" name="clubpassword" id="clubpassword" placeholder="letmein" required>
          <a onclick="joinRequestHelpToggle()" id="joinCodeConfusedButton">Help</a>
          <p id="joinCodeHelp" hidden><br>A short word or words which will be easy to remember. Club members will need to type this to join your club</p>
        </div>
      </div>
      <center>
        <br>
        <button class="primary wide" type="submit">Create Club*</button>
        <p>* Subject to <a href="pages/privacy.html">Privacy Policy</a>
      </center>
    </form>
  </body>
</html>
