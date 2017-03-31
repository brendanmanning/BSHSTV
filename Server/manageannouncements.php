<html>
	<head>
		<title>Manage Announcements</title>
		<link rel="stylesheet" type="text/css" href="mainstyle.css">
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/mu/0.3.0/mu.min.css" />
		
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
		
		<script>
			function get() {
				$.getJSON('http://apps.brendanmanning.com/bshstv/announcements.php', function(data) {
					for(var i = 0; i < data.items.length; i++)
					{
						alert(data[i]["title"]);
					}
				});
			}
		</script>
		
		</head>
		<body onload="get()">
		
		</body>
	