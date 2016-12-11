/* Create object and declare default variables */
var Announcement = function(){
	this.title = null;
	this.text = null;
	this.creator = null;
}

/* Define object setters */
Announcement.prototype.setTitle = function(t) {
	this.title = t;
}
Announcement.prototype.setText = function(t) {
	this.text = t;
}
Announcement.prototype.setCreator = function(c) {
	this.creator = c;
}

/* Define object getters */
Announcement.prototype.getTitle = function() {
	return this.title;
}
Announcement.prototype.getText = function() {
	return this.text;
}
Announcement.prototype.getCreator = function() {
	return this.creator;
}

/* Define other object methods */
Announcement.prototype.hasOptionalMetadata = function() {
	return (this.title != null && this.creator != null);
}