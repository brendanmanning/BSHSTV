function toggleCheckbox(checkbox) {
	// Get the email field
	var emailBox = document.getElementById("email");
	
	// Set it's required property to the checkbox's checked property
	//.. basically, require an email if the user checks the checkbox
	emailBox.required = checkbox.checked;
	
	// Change the email box's placeholder to indicated whether the field is required or not
	emailBox.placeholder = (checkbox.checked ? "Email (Required)" : "Email (Optional)");
}