function joinRequestHelpToggle() {
  var helpText = document.getElementById("joinCodeHelp");
  var helpButton = document.getElementById("joinCodeConfusedButton");

  if(helpText.hidden) {
    helpText.hidden = false;
    helpButton.innerHTML = "Close Help";
  } else {
    helpText.hidden = true;
    helpButton.innerHTML = "Help";
  }
}
