<?php
	class Playlist {
		private $id = null;
		private $name = null;
		private $songs = array();
		private $conn = null;
		public function __construct() {}
		
		public function setID($i) {
			$this->id = $i;
		}	
		
		public function setConn($c) {
			$this->conn = $c;
		}
		
		public function fillMetadata() {
			$sql = $this->conn->prepare("SELECT name FROM playlists WHERE internalid=:plist");
			$sql->bindParam(":plist", $this->id);
			$sql->execute();
			while($row=$sql->fetch()) {
				$this->name = $row['name'];
				break;
			}
		}
		
		public function getSongs() {
			$sql = $this->conn->prepare("SELECT * FROM playlistitems WHERE playlistid=:plist");
			$sql->bindParam(":plist", $this->id);
			$sql->execute();
			
			require_once 'Song.php';
			while($row=$sql->fetch()) {
				$songSQL = $this->conn->prepare("SELECT * FROM songs WHERE internalid=:song");
				$songSQL->bindParam(":song", $row['songid']);
				$songSQL->execute();
				while($r=$songSQL->fetch()) {
					$song = new Song();
					$song->setTitle($r['title']);
					$song->setArtist($r['artist']);
					$song->setAlbum($r['album']);
					$song->setThumbnail($r['thumbnail']);
					$song->setFile($r['file']);
					
					$this->songs[] = $song;
				}
			}
			
			return $this->songs;
		}
		
		public function getName() {
			return $this->name;
		}
	}
?>