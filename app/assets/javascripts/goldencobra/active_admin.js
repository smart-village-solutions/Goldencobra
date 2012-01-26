//= require active_admin/base
$(document).ready(function() {	
	$('textarea.tinymce').tinymce({
		script_url: "/assets/goldencobra/tiny_mce.js",
  		mode : "textareas",
  		theme : "advanced",
  		theme_advanced_buttons1 : "bold, italic, underline, strikethrough, |, bullist, numlist, blockquote, |, undo, redo, |, link, unlink, code",
  		theme_advanced_buttons2 : "",
  		theme_advanced_buttons3 : "",
  		theme_advanced_toolbar_location : "top",
  		theme_advanced_toolbar_align : "center",
  		theme_advanced_resizing : false
	});
});
