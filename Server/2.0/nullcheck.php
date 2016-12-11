<?php
	function isComplete($arr)
	{
		for($i = 0; $i < count($arr); $i++)
		{
			if($arr[$i] == null || $arr[$i] == "") {
				//die($i);
				return false;
			}
		}
		
		return true;
	}