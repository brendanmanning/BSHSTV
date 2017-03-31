<?php
	require '__setup_key.php';
	require '../config.php';
	if($_GET['code'] == $code)
	{
		$conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    	// set the PDO error mode to exception
    	$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		
		$one = "CREATE TABLE IF NOT EXISTS `announcements` (`internalid` int(11) NOT NULL AUTO_ICREMENT,`creator` text NOT NULL,`title` text NOT NULL,`text` text NOT NULL,`date` text NOT NULL,`image` text NOT NULL,`enabled` int(11) NOT NULL DEFAULT '1',`minvisitors` int(11) NOT NULL COMMENT '// If the number of people who are going is below this number, it will be hidden from users in the app',PRIMARY KEY (`internalid`)) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=18 ;";
		$two = "CREATE TABLE IF NOT EXISTS `apikeys` (`internalid` int(11) NOT NULL AUTO_INCREMENT,`apikey` int(11) NOT NULL,`secret` text NOT NULL,`calls` int(11) NOT NULL,`maxcalls` int(11) NOT NULL,`created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,PRIMARY KEY (`internalid`)) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;";
		$three = "CREATE TABLE IF NOT EXISTS `banner` (`internalid` int(11) NOT NULL AUTO_INCREMENT,`bannerText` text NOT NULL,`lastUpdated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,PRIMARY KEY (`internalid`)) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;";
		$four = "CREATE TABLE IF NOT EXISTS `checkins` (`internalid` int(11) NOT NULL AUTO_INCREMENT,`announcementid` int(11) NOT NULL COMMENT '// id from announcement table',`userid` int(11) NOT NULL COMMENT '// An unqiue id for the device',`date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '// Logs when this row was added',PRIMARY KEY (`internalid`)) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=28 ;";
		$five = "CREATE TABLE IF NOT EXISTS `features` (`internalid` int(11) NOT NULL AUTO_INCREMENT,`name` text NOT NULL,`disabledMessage` text NOT NULL COMMENT '//showed to users in app when this feature is unavailable',`enabled` int(11) NOT NULL,`created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,PRIMARY KEY (`internalid`)) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;";
		$six = "CREATE TABLE IF NOT EXISTS `polls` (`id` int(11) NOT NULL AUTO_INCREMENT,`prompt` text NOT NULL,`description` text NOT NULL COMMENT '// same as title',`icon` text NOT NULL,`choiceOne` text NOT NULL,`choiceTwo` text NOT NULL,`choiceThree` text NOT NULL,`choiceFour` text NOT NULL,`creator` text NOT NULL,`date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,`enabled` int(11) NOT NULL DEFAULT '1',PRIMARY KEY (`id`)) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;";
		$seven = "CREATE TABLE IF NOT EXISTS `today` (`internalid` int(11) NOT NULL AUTO_INCREMENT COMMENT '// used just to make individual rows editable in PHYMyAdmin. Not used for anything else',`date` text NOT NULL,`song` text NOT NULL,`artist` text NOT NULL,`bell` int(11) NOT NULL DEFAULT '1',`game` text NOT NULL,`time` text NOT NULL,`at` text NOT NULL,PRIMARY KEY (`internalid`)) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=37 ;";
		$eight = "CREATE TABLE IF NOT EXISTS `userids` (`internalid` int(11) NOT NULL,`userid` int(11) NOT NULL,`date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,UNIQUE KEY `userid` (`userid`)) ENGINE=MyISAM DEFAULT CHARSET=latin1;";
		$nine = "CREATE TABLE IF NOT EXISTS `videos` (`internalid` int(11) NOT NULL AUTO_INCREMENT COMMENT 'without a primary key we can''t delete individual rows in phpmyadmin',`id` text NOT NULL COMMENT 'the youtube video id',`timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'just because',PRIMARY KEY (`internalid`)) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=14 ;";
		$ten = "CREATE TABLE IF NOT EXISTS `votes` (`id` int(11) NOT NULL AUTO_INCREMENT,`onpoll` int(11) NOT NULL,`choicenum` int(11) NOT NULL,`uuid` text NOT NULL,`date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,PRIMARY KEY (`id`)) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=56 ;";
		$statements = array($one,$two,$three,$four,$five,$six,$seven,$eight,$nine,$ten);
		
		for($i = 0; $i < count($statements); $i++) {
    		$stmt = $conn->prepare($statements[$i]);
    		$stmt->execute();
		} 
		
		echo "ok";
	} else {
		echo "403";
	}




/*
//CREATE TABLE IF NOT EXISTS `checkins` (`internalid` int(11) NOT NULL AUTO_INCREMENT,`announcementid` int(11) NOT NULL COMMENT '// id from announcement table',`userid` int(11) NOT NULL COMMENT '// An unqiue id for the device',`date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '// Logs when this row was added',PRIMARY KEY (`internalid`)) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=28 ;
//CREATE TABLE IF NOT EXISTS `features` (`internalid` int(11) NOT NULL AUTO_INCREMENT,`name` text NOT NULL,`disabledMessage` text NOT NULL COMMENT '//showed to users in app when this feature is unavailable',`enabled` int(11) NOT NULL,`created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,PRIMARY KEY (`internalid`)) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;
//CREATE TABLE IF NOT EXISTS `polls` (`id` int(11) NOT NULL AUTO_INCREMENT,`prompt` text NOT NULL,`description` text NOT NULL COMMENT '// same as title',`icon` text NOT NULL,`choiceOne` text NOT NULL,`choiceTwo` text NOT NULL,`choiceThree` text NOT NULL,`choiceFour` text NOT NULL,`creator` text NOT NULL,`date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,`enabled` int(11) NOT NULL DEFAULT '1',PRIMARY KEY (`id`)) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;
//CREATE TABLE IF NOT EXISTS `today` (`internalid` int(11) NOT NULL AUTO_INCREMENT COMMENT '// used just to make individual rows editable in PHYMyAdmin. Not used for anything else',`date` text NOT NULL,`song` text NOT NULL,`artist` text NOT NULL,`bell` int(11) NOT NULL DEFAULT '1',`game` text NOT NULL,`time` text NOT NULL,`at` text NOT NULL,PRIMARY KEY (`internalid`)) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=37 ;

//CREATE TABLE IF NOT EXISTS `userids` (`internalid` int(11) NOT NULL,`userid` int(11) NOT NULL,`date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,UNIQUE KEY `userid` (`userid`)) ENGINE=MyISAM DEFAULT CHARSET=latin1;

//CREATE TABLE IF NOT EXISTS `videos` (`internalid` int(11) NOT NULL AUTO_INCREMENT COMMENT 'without a primary key we can''t delete individual rows in phpmyadmin',`id` text NOT NULL COMMENT 'the youtube video id',`timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'just because',PRIMARY KEY (`internalid`)) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=14 ;

//CREATE TABLE IF NOT EXISTS `votes` (`id` int(11) NOT NULL AUTO_INCREMENT,`onpoll` int(11) NOT NULL,`choicenum` int(11) NOT NULL,`uuid` text NOT NULL,`date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,PRIMARY KEY (`id`)) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=56 ;
?>*/
?>