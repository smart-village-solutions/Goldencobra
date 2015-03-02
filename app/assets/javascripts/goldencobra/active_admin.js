//= require active_admin/base
//= require goldencobra/keymaster
//= require goldencobra/notifications
//= require goldencobra/countable
// require goldencobra/togetherjs  besser in actve_admin_js über url einbinden
//= require goldencobra/jquery.color
//= require goldencobra/jquery.Jcrop.min


//Live Support Settings
var TogetherJSConfig_siteName = "Ikusei GmbH";
var TogetherJSConfig_toolName = "Ikusei Live Support";
var TogetherJSConfig_suppressInvite = true;
var TogetherJSConfig_on = {
  ready: function(){
    $.ajax({
      url: "/call_for_support",
      data: "link=" + encodeURIComponent(TogetherJS.shareUrl())
    });
  }
};

$(function() {

  //Wenn es get_goldencobra_articles_per_remote im 'Artikel bearbeiten' gibt,
  // hole alle Goldencobra:Article :id,:title, :ancestry
  var $select_parent_articles = $(".get_goldencobra_articles_per_remote");
  if ( $select_parent_articles.length ){
    $.ajax({
      url: "/api/v2/articles.json"
    }).done(function(data){
      var selected_parent_id = $select_parent_articles.find("option:selected").val();
      $select_parent_articles.html("<option value=''></option>");
      $.each( data, function(index,value){
        var selected_option = "";
        if (value.id == selected_parent_id){
          selected_option = " selected='selected' ";
        } 
        $select_parent_articles.append("<option value='" + value.id + "' " + selected_option + ">" + value.parent_path + "</option>")  ;
      });
      $select_parent_articles.trigger("chosen:updated");
      return false;
    });
  }

  //Importer optionen Ein und Ausblendbar machen
  $("table.importer_assoziations tr.head td.nested_model_header span.button").bind("click", function(){
    var id_to_class = $(this).closest(".head").attr("id");
    $("tr.model_group." + id_to_class).toggle();
    if ($(this).html() == "Felder anzeigen"){
      $(this).html("Felder ausblenden");
    }else{
      $(this).html("Felder anzeigen");
    }
  });

  if (typeof tinyMCESetting_theme_advanced_blockformats === "undefined") {
    var tinyMCESetting_theme_advanced_blockformats = "p,h1,h2,h3,div";
  }

  $("textarea.tinymce-no-buttons").tinymce({
    script_url: "/assets/goldencobra/tiny_mce.js",
    mode: "textareas",
    theme: "advanced",
    theme_advanced_buttons1: "",
    theme_advanced_buttons2: "",
    theme_advanced_buttons3: "",
    theme_advanced_toolbar_location: "top",
    theme_advanced_toolbar_align: "center",
    theme_advanced_resizing: false,
    relative_urls: true,
    convert_urls: false,
    theme_advanced_blockformats: tinyMCESetting_theme_advanced_blockformats,
    plugins: "autolink,paste",
    dialog_type: "modal",
    paste_auto_cleanup_on_paste: true
  });


	$('textarea.tinymce').tinymce({
		script_url: "/assets/goldencobra/tiny_mce.js",
    mode: "textareas",
    theme: "advanced",
    theme_advanced_buttons1: "formatselect, bold, italic, underline, strikethrough,|, bullist, numlist, blockquote, |, pastetext,pasteword, |, undo, redo, |, link, unlink, code, fullscreen",
    theme_advanced_buttons2: "",
    theme_advanced_buttons3: "",
    theme_advanced_toolbar_location: "top",
    theme_advanced_toolbar_align: "center",
    theme_advanced_resizing: false,
		relative_urls: true,
    convert_urls: false,
    theme_advanced_blockformats: tinyMCESetting_theme_advanced_blockformats,
		plugins: "fullscreen,autolink,paste",
		dialog_type: "modal",
		paste_auto_cleanup_on_paste: true
	});

	$('textarea.tinymce_extended').tinymce({
		script_url: "/assets/goldencobra/tiny_mce.js",
    mode: "textareas",
    theme: "advanced",
    theme_advanced_buttons1: "formatselect, bold, italic, underline, strikethrough,|, bullist, numlist, blockquote, |, pastetext,pasteword, |, undo, redo, |, link, unlink, code, fullscreen",
    theme_advanced_buttons2: "removeformat, fontsizeselect, forecolor, backcolor, forecolorpicker, backcolorpicker",
    theme_advanced_buttons3: "tablecontrols",
    theme_advanced_toolbar_location: "top",
    theme_advanced_toolbar_align: "left",
    theme_advanced_resizing: false,
		relative_urls: true,
    convert_urls: false,
    theme_advanced_blockformats: tinyMCESetting_theme_advanced_blockformats,
		plugins: "fullscreen,autolink,paste,table",
		dialog_type: "modal",
		paste_auto_cleanup_on_paste: true,
		verify_html: false
	});

  //TextCounter auf title, subtitle, Teaser, Summary, Breadcrumb, url_name
  teaser = $('#article_title, #article_subtitle, #article_teaser, #article_breadcrumb, #article_url_name, #article_summary, #widget_teaser, #widget_description').each(function(index){
    Countable.live($(this)[0], function(counter) {
      if (!$(this).siblings('.char_count').length) {
        $(this).wrap("<div></div>");
        $(this).after("<div class='char_count'></div>");
      }
      $(this).siblings(".char_count").html("Zeichen: " + counter.all);
      //console.warn(counter);
    });
  });

  //Foldable overview in sidebar
  $("div.overview-sidebar div.folder").live("click", function(){
    $(this).closest('li').find("ul:first").slideToggle();
  });
  $("div.overview-sidebar div.folder").trigger("click");

  //Add Button Background Jobs zu Settings
	//$('#einstellungen ul').append("<li><a href='/admin/background'>Background Jobs</a></li>")

	$('.metadescription_hint').tinymce({
		script_url: "/assets/goldencobra/tiny_mce.js",
      mode: "textareas",
      theme: "advanced",
      readonly: 1,
      theme_advanced_default_background_color: "#f4f4f4",
      theme_advanced_buttons1: "",
      theme_advanced_buttons2: "",
      theme_advanced_buttons3: "",
      theme_advanced_toolbar_location: "bottom",
      theme_advanced_toolbar_align: "center",
      theme_advanced_resizing: false,
      body_id: "metadescription-tinymce-body",
      content_css: "/assets/goldencobra/active_admin.css"
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

	$('#footer').html("<p>Goldencobra</p>");

	//die fieldsets bekommen einen button zum auf und zu klappen
	$('div#main_content > form > fieldset.foldable > legend').prepend("<div class='foldable_icon_wrapper'><div class='foldable_icon'></div></div>");
	$('div#main_content > form > fieldset.foldable > legend').bind("click", function(){
		$(this).closest("fieldset").find(".foldable_icon").toggleClass("open");
		$(this).closest("fieldset").find('ol').slideToggle();
	});
	$('div#main_content > form > fieldset.foldable.closed legend').trigger("click");

  //die sidebar_section bekommen einen button zum auf und zu klappen
  $('div#sidebar div.sidebar_section h3').prepend("<div class='foldable_icon_wrapper'><div class='foldable_icon'></div></div>");
  $('div#sidebar div.sidebar_section h3').bind("click", function(){
    $(this).closest(".sidebar_section").find(".foldable_icon").toggleClass("open");
    $(this).closest(".sidebar_section").find('.panel_contents').slideToggle();
	});
	$('div#sidebar div.sidebar_section:not(#layout_positions_sidebar_section) h3').trigger("click");
  $('div#sidebar div.sidebar_section .warning').closest("div.sidebar_section").addClass("warning").find("h3").trigger("click");

  $(".chzn-select").chosen();
  $(".chzn-select-deselect").chosen({ allow_single_deselect: true });
  $("a.button").live("click", function(){
    $(".chzn-select").chosen();
    $(".chzn-select-deselect").chosen({ allow_single_deselect: true });
  });

  //Menuepunkte bekommen eine funktion zum auf und zu klappen
  $('div#overview_sidebar div.title a').bind("click", function(){
    $(this).children("ul").hide();
  });

  $('div#overview_sidebar div.title a').trigger("click");

  $("#main_content form:not(.without_short_key) input:submit").attr("value", $("#main_content form input:submit").attr("value") + " (⌘-S)");
  
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

  //Short Key for Life support on every Page
  key('⌘+k, ctrl+k', function(){
    call_for_help();
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
    var addCssBox = {"float": "left", "width": "50px", "margin-top": "8px"};
    $(el).height(50).find("label").css(addCssBox);
    // selektoren für start und end inputs eines tages
    var startInput = $("#widget_offline_time_start_" + engDaysShort[i] + "_input");
    var endInput = $("#widget_offline_time_end_" + engDaysShort[i] + "_input");
    // label der inputs entfernen und benötigten css style ergänzen
    var addCssInput = {"float": "left", "width": "180px"};
    $(startInput).css(addCssInput).find("label").remove();
    $(endInput).css(addCssInput).find("label").remove();
    // inputs zur checkbox gruppieren
    $(startInput).appendTo(el);
    $(endInput).appendTo(el);
  });
  /**** END DOM Manipulation *****/

  $("ul.link_checker_ul div.link_checker_label").click(function(){
    $(this).siblings(".link_checker_sources").toggle();
  });
  
  // optimize header menu bar
  $('#utility_nav').after('<div style="clear: both;"></div>');
  $('#wrapper > #header').css('height', 'auto').css('min-width', '890px').css('filter', 'none');

  // own logo per app from settings url
  changeLogoFromSetting();
});

function call_for_help(argument) {
  TogetherJS(this);
  return false;
}


/**
 *
 * get ajax logo url for chanigng admin backend logo picture
 *
 */
function changeLogoFromSetting() {
  $.ajax({
    type   : 'GET',
    url    : '/api/v2/setting_string',
    data   : { 'setting_key': 'goldencobra.random_logo_url' },
    success: function (data) {
      if (data && data.indexOf('translation missing') == -1) {
        // change background image of header logo
        $('#header h1').css('background', 'url("' + data + '") no-repeat scroll center top / 100px auto rgba(0, 0, 0, 0)');
      } else {
        // set standard url of header logo for fallback
        $('#header h1').css('background', 'url("/assets/goldencobra/cobra.png") no-repeat scroll center top / auto auto rgba(0, 0, 0, 0)');
      }
    }
  });
}