function showFeatures()
{
	document.getElementById("featuresDiv").style.visibility = 'visible';
	hideAllExcept("featuresDiv");
}

function showScreenshots()
{
	document.getElementById("screenshotsDiv").style.visibility = 'visible';
	hideAllExcept("screenshotsDiv");
}

function showContactForm()
{
	document.getElementById("contactDiv").style.visibility = 'visible';
	hideAllExcept("contactDiv");
}

function hideAllExcept(div) {
	var divs = ["featuresDiv","screenshotsDiv","contactDiv"];
	
	for(var i = 0; i < divs.length; i++)
	{
		if(divs[i] != div)
		{
			document.getElementById(divs[i]).style.visibility = 'hidden';
			document.getElementById(divs[i]).style.height = '0px';
		} else {
			document.getElementById(divs[i]).style.height = '100%';
		}
	}
}