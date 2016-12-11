var Slideshow = function() {
	this.announcements = null;
	this.currentSlide = 0;
}
Slideshow.prototype.setAnnouncements = function(a) {
	this.announcements = a;
}
Slideshow.prototype.getTitle = function() {
	return (this.announcements != null) ? this.announcements[this.currentSlide].getTitle() : null;
}
Slideshow.prototype.getText = function() {
	return (this.announcements != null) ? this.announcements[this.currentSlide].getText() : null;
}
Slideshow.prototype.getCreator = function() {
	return (this.announcements != null) ? this.announcements[this.currentSlide].getCreator() : null;
}
Slideshow.prototype.canAdvance = function() {
	return (this.currentSlide < this.announcements.length);
}
Slideshow.prototype.advance = function() {
	this.currentSlide++;
}

Slideshow.prototype.canGoBack = function() {
	return (this.currentSlide > 0);
}
Slideshow.prototype.goBack = function() {
	this.currentSlide--;
}