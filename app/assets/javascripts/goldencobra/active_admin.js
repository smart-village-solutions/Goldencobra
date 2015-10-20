//= require active_admin/base
//= require goldencobra/keymaster
//= require goldencobra/notifications
//= require goldencobra/countable
//= require goldencobra/chosen.jquery
//= require goldencobra/jquery.color-2.1.2
//= require goldencobra/jquery.Jcrop.min
//= require goldencobra/react_0.13.1.min
//= require goldencobra/components
//= require goldencobra/pagination
// require goldencobra/togetherjs  besser in actve_admin_js über url einbinden

//= require goldencobra/html_editors/general
//= require goldencobra/html_editors/tinymce_v3/tinymce_v3_inits
//= require goldencobra/html_editors/tinymce_v4/tinymce_v4_inits
//= require goldencobra/html_editors/ckeditor/ckeditor_inits

$(function () {
  // wenn wir auf der Dashboardseite sind und es eine Suche gibt
  var $dashboard_article_search = $('#dashboard_article_search');
  if ($dashboard_article_search.length) {
    $('body').on('change', '#dashboard_article_search', function() {
      var article_id = $('#dashboard_article_search').find('option:selected').val();
      if (article_id) {
        window.location.href = '/admin/articles/' + article_id + '/edit';
      }
    });
  }

  // Wenn es get_goldencobra_articles_per_remote im 'Artikel bearbeiten' gibt,
  // hole alle Goldencobra:Article :id, :title, :ancestry
  var $select_parent_articles = $('.get_goldencobra_articles_per_remote');
  if ($select_parent_articles.length){
    $.ajax({
      url: '/api/v2/articles.json?react_select=true'
    }).done(function(data){
      var $this             = $select_parent_articles.get(0);
      var thisId            = $this.id;
      var thisName          = $this.name;
      var className         = $this.className;
      var selectedParentId  = $($this).find('option:selected').val();

      $this.outerHTML = "<div id='react-" + thisId + "'></div>";
      React.render(
        React.createElement(SelectList, {
          id: thisId,
          value: selectedParentId,
          options: data,
          name: thisName,
          className: className,
          firstBlank: true,
          dataPlaceholder: "Artikel wählen"
        }),
        document.getElementById('react-' + thisId)
      );

      var $thisEl = $('#' + thisId);
      // $thisEl.parents('.select.input').find('.chosen-container.chosen-container-single').remove();
      if ($('.get_goldencobra_articles_per_remote').hasClass("include_blank_false")){
        $thisEl.chosen({ allow_single_deselect: false });
      } else {
        $thisEl.chosen({ allow_single_deselect: true });
      }

      $('.chosen-container').css({width: '80%'});
      $('#sidebar .chosen-container').css({width: '100%'});
      return false;
    });
  }

  // goldencobra uploads per react
  populateArticleUploads();

  // GCZ-28
  $('.has_many_container.article_images a.button.has_many_add').on('click', function() {
    setTimeout(populateArticleUploads, 100);
  });

  //Importer optionen Ein und Ausblendbar machen
  $('table.importer_assoziations tr.head td.nested_model_header span.button').bind('click', function() {
    var id_to_class = $(this).closest('.head').attr('id');
    $('tr.model_group.' + id_to_class).toggle();
    if ($(this).html() == 'Felder anzeigen'){
      $(this).html('Felder ausblenden');
    } else {
      $(this).html('Felder anzeigen');
    }
  });

  // text counter auf title, subtitle, teaser, breadcrumb, url_name, widget teaser, widget description
  $('#article_title, #article_subtitle, #article_teaser, #article_breadcrumb, #article_url_name, #widget_teaser, #widget_description').each(function (index) {
    Countable.live($(this)[0], function (counter) {
      if (!$(this).siblings('.char_count').length) {
        $(this).wrap('<div></div>');
        $(this).after("<div class='char_count'></div>");
      }
      $(this).siblings('.char_count').html('Zeichen: ' + counter.all);
      //console.warn(counter);
    });
  });

  //Foldable overview in sidebar
  $('body').on('click', 'div.overview-sidebar div.folder' , function() {
    $(this).closest('li').find('ul:first').slideToggle();
  });
  $('div.overview-sidebar div.folder').trigger('click');

  //Add Button Background Jobs zu Settings
	//$('#einstellungen ul').append("<li><a href='/admin/background'>Background Jobs</a></li>")

  function postInitWork() {
    var editor = tinyMCE.getInstanceById('metadescription-tinymce');
    editor.getBody().style.backgroundColor = '#F4f4f4';
  }

	//Image Manager
	$('a#open_goldencobra_image_maganger').bind('click', function() {
		$('#goldencobra_image_maganger').fadeToggle();
		return false;
	});

	$('#goldencobra_image_maganger').draggable({
		handle: '.header'
	});

	$('#goldencobra_image_maganger div.header div.close').bind('click', function() {
		$('#goldencobra_image_maganger').fadeOut();
	});

  // version
	$('#footer').html('<p>Golden Cobra 2.0</p>');

	//die fieldsets bekommen einen button zum auf und zu klappen
	$('div#main_content > form > fieldset.foldable > legend').prepend("<div class='foldable_icon_wrapper'><div class='foldable_icon'></div></div>");
	$('div#main_content > form > fieldset.foldable > legend').bind('click', function() {
		$(this).closest('fieldset').find('.foldable_icon').toggleClass('open');
		$(this).closest('fieldset').find('ol').slideToggle();
	});
	$('div#main_content > form > fieldset.foldable.closed legend').trigger('click');

  //die sidebar_section bekommen einen button zum auf und zu klappen
  $('div#sidebar div.sidebar_section h3').prepend("<div class='foldable_icon_wrapper'><div class='foldable_icon'></div></div>");
  $('div#sidebar div.sidebar_section h3').bind("click", function() {
    $(this).closest(".sidebar_section").find('.foldable_icon').toggleClass("open");
    $(this).closest(".sidebar_section").find('.panel_contents').slideToggle();
	});
	$('div#sidebar div.sidebar_section:not(#layout_positions_sidebar_section) h3').trigger('click');
  $('div#sidebar div.sidebar_section .warning').closest('div.sidebar_section').addClass('warning').find('h3').trigger('click');

  //die Settings sub groups bekommen ein button zum aufklappen
  $('div#goldencobra_settings_wrapper .foldable').prepend("<div class='foldable_icon_wrapper'><div class='foldable_icon'></div></div>");
  $('div#goldencobra_settings_wrapper .foldable').bind('click', function() {
    $(this).closest('.settings_group_title').find('.foldable_icon').toggleClass('open');
    $(this).closest('.settings_level').children('.settings_sub_group').slideToggle();
  });

  /* init chosen */
  $('.chosen-select').chosen();
  $('.chosen-select-deselect').chosen({ allow_single_deselect: true });
  $('a.button').on('click', function () {
    setTimeout(function initChosens() {
      $('.chosen-select').chosen();
      $('.chosen-select-deselect').chosen({ allow_single_deselect: true });
    }, 20);
  });

  /* create pagination links in overviews */
  initPaginationLinks();

  /* create pagination links in overviews */
  moveBatchActionsIndexHeader();

  //Menuepunkte bekommen eine funktion zum auf und zu klappen
  $('div#overview_sidebar div.title a').bind('click', function () {
    $(this).children('ul').hide();
  });

  $('div#overview_sidebar div.title a').trigger('click');

  $('#main_content form:not(.without_short_key) input:submit').attr('value',
    $('#main_content form input:submit').attr('value') + ' (⌘-S)');

  key('⌘+s, ctrl+s', function () {
    $('#main_content form input:submit').trigger('click');
    return false;
  });

  $('body.show #title_bar .action_items a[href$="edit"]').append(' (⌘-E)');
    key('⌘+e, ctrl+e', function () {
    target = $('#title_bar .action_items a[href$="edit"]').attr('href');
    window.location = target;
    return false;
  });

  // $("#title_bar .action_items a[href$='revert']").append(" (⌘-Z)");
  // key('⌘+z, ctrl+z', function() {
	// target = $("#title_bar .action_items a[href$='revert']").attr("href");
	// window.location = target;
	// return false;
  // });

  /**** DOM Manipulation Zeitsteuerung ****/
  /* text input felder für den jeweiligen
     tag in dom gruppieren */

  // hilfsarray tage englisch kurz
  var engDaysShort = ['mo', 'tu', 'we', 'th', 'fr', 'sa', 'su'];
  // tages checkboxen elemente (mo, di, ..., so)
  var checkBoxesDays = $('.choice');
  // für jede checkbox die dazugehörigen input felder holen und anhängen
  checkBoxesDays.each(function(i, el) {
    // checkbox muss neue css styles erhalten
    var addCssBox = {'float': 'left', 'width': '50px', 'margin-top': '8px'};
    $(el).height(50).find('label').css(addCssBox);
    // selektoren für start und end inputs eines tages
    var startInput = $('#widget_offline_time_start_' + engDaysShort[i] + '_input');
    var endInput = $('#widget_offline_time_end_' + engDaysShort[i] + '_input');
    // label der inputs entfernen und benötigten css style ergänzen
    var addCssInput = {'float': 'left', 'width': '180px'};
    $(startInput).css(addCssInput).find('label').remove();
    $(endInput).css(addCssInput).find('label').remove();
    // inputs zur checkbox gruppieren
    $(startInput).appendTo(el);
    $(endInput).appendTo(el);
  });
  /**** END DOM Manipulation *****/

  $('ul.link_checker_ul div.link_checker_label').click(function() {
    $(this).siblings('.link_checker_sources').toggle();
  });

  // optimize header menu bar
  $('#utility_nav').after('<div style="clear: both;"></div>');
  $('#wrapper > #header').css('height', 'auto').css('min-width', '890px').css('filter', 'none');

  // own logo per app from settings url
  changeLogoFromSetting();
});

/**
 *
 * get ajax logo url for changing admin backend logo picture
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

// Wenn es get_goldencobra_uploads_per_remote im 'Artikel bearbeiten' gibt,
// hole alle Goldencobra:Uploads :id, :complete_list_name
function populateArticleUploads() {
  var $selectArticleUploads = $('.get_goldencobra_uploads_per_remote').not('.reacted');
  if ($selectArticleUploads.length) {
    $.ajax({
      url: '/api/v2/uploads.json'
    }).done(function (data) {
      var thisData = data;
      $selectArticleUploads.each(function (index, element) {
        var $this = element;
        var thisId = element.id;
        var thisName = element.name;
        var includeBlank = $(element).hasClass('chosen-select-deselect');
        var selectedUploadId = $(element).find('option:selected').val();

        $this.outerHTML = "<div id='react-" + thisId + "'></div>";
        React.render(
          React.createElement(SelectList, {id: thisId, value: selectedUploadId, options: thisData, name: thisName, firstBlank: includeBlank}),
          document.getElementById('react-' + thisId)
        );

        var $thisEl = $('#' + thisId);

        $thisEl.parents('.select.input').find('.chosen-container.chosen-container-single').remove();
        if (includeBlank){
          $thisEl.chosen({ allow_single_deselect: true });
        } else {
          $thisEl.chosen();
        }
        $('.chosen-container').css({width: '80%'});
      });
      return false;
    });
  }
}
