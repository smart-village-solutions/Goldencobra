//= require active_admin/base
$(document).ready(function() {	
	$('textarea.tinymce').tinymce({
		script_url: "/assets/goldencobra/tiny_mce.js",
  		mode : "textareas",
  		theme : "advanced",
  		theme_advanced_buttons1 : "formatselect, bold, italic, underline, strikethrough, |, bullist, numlist, blockquote, |, pastetext,pasteword, |, undo, redo, |, link, unlink, code, fullscreen",
  		theme_advanced_buttons2 : "",
  		theme_advanced_buttons3 : "",
  		theme_advanced_toolbar_location : "top",
  		theme_advanced_toolbar_align : "center",
  		theme_advanced_resizing : false, 
		relative_urls : true,
		theme_advanced_blockformats : "p,h1,h2,h3,div",
		plugins : "fullscreen,autolink,inlinepopups,paste",
		dialog_type : "modal",
		paste_auto_cleanup_on_paste : true
	});
});
