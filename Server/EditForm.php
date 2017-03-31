<?php
	class EditForm {
		$elements = array();	
		$handler;
		$method;
		$buttonText;
		$buttonClass;
		$title;
		$headers;
		function pageTitle($t) {
			$title = $t;
		}
		function setHeaders($h) {
			$headers = $h;
		}
		function addElement($fe) {
			$elements[] = $fe;
		}
		
		function setHandler($page) {
			$handler = $page;
		}
		
		function setMethod($m) {
			$method = $m;
		}
		
		function setButtonText($b) {
			$buttonText = $b;
		}
		function setButtonClass($c) {
			$buttonClass = $c;
		}
		
		function render() {
			$html .= "<html><head>" . $headers . "<title>" . $title . "</title></head><body>"; 
			$html .= '<form action="' . $handler . '" method="' . $method . '">';
			for($i = 0; $i < count($elements); $i++) {
				$html .= '<input type="text" placeholder="' . $elements[$i]->placeholder . '" class="' . $elements[$i]->class . '" name="' . $elements[$i]->postName . '"><br>';
			}
			$html .= '<button class="' . $buttonClass . '">' . $buttonText . '</button>';
			$html .= '</form></body></html>';
			return $html;
		}
	}
	
	class EditFormElement {
		public $placeholder;
		public $postName;
		public $class;
	}
?>