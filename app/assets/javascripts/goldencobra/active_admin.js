//= require active_admin/base

$(document).ready(function() {	
	$('textarea.tinymce').tinymce({
		script_url: "/assets/goldencobra/tiny_mce.js",
  		mode : "textareas",
  		theme : "advanced",
  		theme_advanced_buttons1 : "formatselect, bold, italic, underline, strikethrough,|, bullist, numlist, blockquote, |, pastetext,pasteword, |, undo, redo, |, link, unlink, code, fullscreen",
  		theme_advanced_buttons2 : "",
  		theme_advanced_buttons3 : "",
  		theme_advanced_toolbar_location : "top",
  		theme_advanced_toolbar_align : "center",
  		theme_advanced_resizing : false, 
		relative_urls : true,
		theme_advanced_blockformats : "p,h1,h2,h3,div",
		plugins : "fullscreen,autolink,paste",
		dialog_type : "modal",
		paste_auto_cleanup_on_paste : true
	});
	
	
	
	//Image Manager
	$("a#open_goldencobra_image_maganger").bind("click", function(){
		$("#goldencobra_image_maganger").fadeToggle();
		return false;
	});
	
	$("#goldencobra_image_maganger").draggable({
		handle: ".header"
	});
	
	$("#goldencobra_image_maganger div.header div.close").bind("click", function(){
		$("#goldencobra_image_maganger").fadeOut();
	});
	
	$('#footer').html("<p>Goldencobra</p>")
	
});

