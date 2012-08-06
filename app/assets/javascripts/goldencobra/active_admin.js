//= require active_admin/base
//= require goldencobra/keymaster

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


  //Add Button Background Jobs zu Settings 
	$('#einstellungen ul').append("<li><a href='/admin/background'>Background Jobs</a></li>")
	
	$('.metadescription_hint').tinymce({
		script_url: "/assets/goldencobra/tiny_mce.js",
  		mode : "textareas",
  		theme : "advanced",
      readonly: 1,
      theme_advanced_default_background_color : "#f4f4f4",
  		theme_advanced_buttons1 : "",
  		theme_advanced_buttons2 : "",
  		theme_advanced_buttons3 : "",
  		theme_advanced_toolbar_location : "bottom",
  		theme_advanced_toolbar_align : "center",
  		theme_advanced_resizing : false,
      body_id : "metadescription-tinymce-body",
      content_css : "/assets/goldencobra/active_admin.css"
  });

  function postInitWork()
  {
    var editor = tinyMCE.getInstanceById('metadescription-tinymce');
    editor.getBody().style.backgroundColor = "#F4f4f4";
  }
	
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
	
	//die fieldsets bekommen einen button zum auf und zu klappen
	$('div#main_content fieldset.foldable legend').prepend("<div class='foldable_icon_wrapper'><div class='foldable_icon'></div></div>")
	$('div#main_content fieldset.foldable legend').bind("click", function(){
		$(this).closest("fieldset").find(".foldable_icon").toggleClass("open");
		$(this).closest("fieldset").find('ol').slideToggle();
	});
	$('div#main_content fieldset.foldable.closed legend').trigger("click");
	
	
	//die sidebar_section bekommen einen button zum auf und zu klappen
	$('div#sidebar div.sidebar_section h3').prepend("<div class='foldable_icon_wrapper'><div class='foldable_icon'></div></div>")
	$('div#sidebar div.sidebar_section h3').bind("click", function(){
		$(this).closest(".sidebar_section").find(".foldable_icon").toggleClass("open");
		$(this).closest(".sidebar_section").find('.panel_contents').slideToggle();
	});
	$('div#sidebar div.sidebar_section:not(#overview_sidebar_section) h3').trigger("click");
	
	$(".chzn-select").chosen();
  $(".chzn-select-deselect").chosen({allow_single_deselect:true});

  //Menuepunkte bekommen eine funktion zum auf und zu klappen
  $('div#overview_sidebar div.title a').bind("click", function(){
  	$(this).children("ul").hide();
  	
  });
  	$('div#overview_sidebar div.title a').trigger("click");

  $("#main_content form input:submit").attr("value", $("#main_content form input:submit").attr("value") + " (⌘-S)");
  key('⌘+s, ctrl+s', function(){
	$("#main_content form input:submit").trigger("click");
	return false;
  });

  $("#title_bar .action_items a[href$='edit']").append(" (⌘-E)")
  key('⌘+e, ctrl+e', function(){
	target = $("#title_bar .action_items a[href$='edit']").attr("href");
	window.location = target;
	return false;
  });

  $("#title_bar .action_items a[href$='revert']").append(" (⌘-Z)")
  key('⌘+z, ctrl+z', function(){
	target = $("#title_bar .action_items a[href$='revert']").attr("href");
	window.location = target;
	return false;
  });


	
 


});

