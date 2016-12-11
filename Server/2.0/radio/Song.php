<?php
	class Song {
	
		public $title = null;
		public $artist = null;
		public $album = null;
		public $thumbnail = null;
		public $file = null;
		
		public function __construct() {}
		
		public function setTitle($t) {
			$this->title = $t;
		}
		
		public function setArtist($a) {
			$this->artist = $a;
		}
		
		public function setAlbum($al) {
			$this->album = $al;
		}
		
		public function setThumbnail($t) {
			$this->thumbnail = $t;
		}
		
		public function setFile($f) {
			$this->file = $f;
		}
	}
?>