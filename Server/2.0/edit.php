<?php
	$form = new EditForm();
	
	$form->setTitle("Edit Value");
	$form->setHeaders('<link rel="stylesheet" type="text/css" href="mainstyle.css"><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/mu/0.3.0/mu.min.css" />');
	$form->setHandler("edit-value.php");
	$form->setMethod("POST");
	
	$