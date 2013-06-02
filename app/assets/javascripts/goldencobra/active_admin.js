//= require active_admin/base
//= require goldencobra/keymaster

$(function() {
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
    convert_urls : false,
		theme_advanced_blockformats : "p,h1,h2,h3,div",
		plugins : "fullscreen,autolink,paste",
		dialog_type : "modal",
		paste_auto_cleanup_on_paste : true
	});

	$('textarea.tinymce_extended').tinymce({
		script_url: "/assets/goldencobra/tiny_mce.js",
  		mode : "textareas",
  		theme : "advanced",
  		theme_advanced_buttons1 : "formatselect, bold, italic, underline, strikethrough,|, bullist, numlist, blockquote, |, pastetext,pasteword, |, undo, redo, |, link, unlink, code, fullscreen",
  		theme_advanced_buttons2 : "removeformat, fontsizeselect, forecolor, backcolor, forecolorpicker, backcolorpicker",
  		theme_advanced_buttons3 : "tablecontrols",
  		theme_advanced_toolbar_location : "top",
  		theme_advanced_toolbar_align : "center",
  		theme_advanced_resizing : false,
		relative_urls : true,
    convert_urls : false,
		theme_advanced_blockformats : "p,h1,h2,h3,div",
		plugins : "fullscreen,autolink,paste,table",
		dialog_type : "modal",
		paste_auto_cleanup_on_paste : true
	});


  //Foldable overview in sidebar
  $("div.overview-sidebar div.folder").bind("click", function(){
    $(this).closest('li').find("ul:first").slideToggle();
  });
  $("div.overview-sidebar div.folder").trigger("click");

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

  function postInitWork() {
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
	$('div#main_content > form > fieldset.foldable > legend').prepend("<div class='foldable_icon_wrapper'><div class='foldable_icon'></div></div>")
	$('div#main_content > form > fieldset.foldable > legend').bind("click", function(){
		$(this).closest("fieldset").find(".foldable_icon").toggleClass("open");
		$(this).closest("fieldset").find('ol').slideToggle();
	});
	$('div#main_content > form > fieldset.foldable.closed legend').trigger("click");


	//die sidebar_section bekommen einen button zum auf und zu klappen
	$('div#sidebar div.sidebar_section h3').prepend("<div class='foldable_icon_wrapper'><div class='foldable_icon'></div></div>")
	$('div#sidebar div.sidebar_section h3').bind("click", function(){
		$(this).closest(".sidebar_section").find(".foldable_icon").toggleClass("open");
		$(this).closest(".sidebar_section").find('.panel_contents').slideToggle();
	});
	$('div#sidebar div.sidebar_section:not(#overview_sidebar_section) h3').trigger("click");
  $('div#sidebar div.sidebar_section .warning').closest("div.sidebar_section").addClass("warning").find("h3").trigger("click");

	$(".chzn-select").chosen();
  $(".chzn-select-deselect").chosen({allow_single_deselect:true});

  //Menuepunkte bekommen eine funktion zum auf und zu klappen
  $('div#overview_sidebar div.title a').bind("click", function(){
  	$(this).children("ul").hide();
  });

  $('div#overview_sidebar div.title a').trigger("click");

  $("#main_content form input:submit").attr("value", $("#main_content form input:submit").attr("value") + " (⌘-S)");
  key('⌘+s, ctrl+s', function() {
  	$("#main_content form input:submit").trigger("click");
  	return false;
  });

  $("body.show #title_bar .action_items a[href$='edit']").append(" (⌘-E)");
    key('⌘+e, ctrl+e', function(){
	 target = $("#title_bar .action_items a[href$='edit']").attr("href");
	 window.location = target;
	 return false;
  });

  // $("#title_bar .action_items a[href$='revert']").append(" (⌘-Z)");
  // key('⌘+z, ctrl+z', function(){
	// target = $("#title_bar .action_items a[href$='revert']").attr("href");
	// window.location = target;
	// return false;
  // });

  $('.expert').hide();

  /**** DOM Manipulation Zeitsteuerung ****/
  /* text input felder für den jeweiligen
     tag in dom gruppieren */

  // hilfsarray tage englisch kurz
  var engDaysShort = ["mo", "tu", "we", "th", "fr", "sa", "su"];
  // tages checkboxen elemente (mo, di, ..., so)
  var checkBoxesDays = $(".choice");
  // für jede checkbox die dazugehörigen input felder holen und anhängen
  checkBoxesDays.each(function(i, el) {
    // checkbox muss neue css styles erhalten
    var addCssBox = {"float" : "left", "width" : "50px", "margin-top" : "8px"};
    $(el).height(50).find("label").css(addCssBox);
    // selektoren für start und end inputs eines tages
    var startInput = $("#widget_offline_time_start_" + engDaysShort[i] + "_input");
    var endInput = $("#widget_offline_time_end_" + engDaysShort[i] + "_input");
    // label der inputs entfernen und benötigten css style ergänzen
    var addCssInput = {"float" : "left", "width" : "180px"};
    $(startInput).css(addCssInput).find("label").remove();
    $(endInput).css(addCssInput).find("label").remove();
    // inputs zur checkbox gruppieren
    $(startInput).appendTo(el);
    $(endInput).appendTo(el);
  });
  /**** END DOM Manipulation *****/
});


//Notifications
function notify(title,body,token) {
    // check for notification compatibility
    if(!window.Notification) {
        // if browser version is unsupported, be silent
        return;
    }
    // log current permission level
    console.log(Notification.permissionLevel());
    // if the user has not been asked to grant or deny notifications from this domain
    if(Notification.permissionLevel() === 'default') {
        Notification.requestPermission(function() {
            // callback this function once a permission level has been set
            notify();
        });
    }
    // if the user has granted permission for this domain to send notifications
    else if(Notification.permissionLevel() === 'granted') {
        var n = new Notification(
                    title,
                    { 'body': body,
                      // prevent duplicate notifications
                      'tag' : token,
                      'onclick': function(){
                        console.log("notification clicked");
                      },
                      // callback function when the notification is closed
                      'onclose': function() {
                           console.log('notification closed');
                       }
                    }
                );
    }
    // if the user does not want notifications to come from this domain
    else if(Notification.permissionLevel() === 'denied') {
      // be silent
      return;
    }
}

