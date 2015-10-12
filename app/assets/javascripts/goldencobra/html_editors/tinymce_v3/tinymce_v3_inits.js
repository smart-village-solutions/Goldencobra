function initTinyMCEv3() {
  var jsTag = document.createElement('script');
  jsTag.type = 'text/javascript';
  jsTag.src = '/assets/goldencobra/html_editors/tinymce_v3/jquery.tinymce_v3.js';
  document.getElementsByTagName('head')[0].appendChild(jsTag);

  var tags = '';
  var buttons = '';

  $.ajax({
    type   : 'GET',
    url    : '/api/v2/setting_string',
    data   : { 'setting_key': 'goldencobra.html_textarea.tinymce_v3_setup_tags' },
    success: function (data) {
      if (data && data.indexOf('translation missing') == -1) {
        // return value of setting key
        tags = data;
      } else {
        // set standard
        tags = 'p, h1, h2, h3, div';
      }

      $.ajax({
        type   : 'GET',
        url    : '/api/v2/setting_string',
        data   : { 'setting_key': 'goldencobra.html_textarea.tinymce_v3_setup_buttons' },
        success: function (data) {
          if (data && data.indexOf('translation missing') == -1) {
            // return value of setting key
            buttons = data;
          } else {
            // set standard
            buttons = 'formatselect, bold, italic, underline, strikethrough, |, bullist, numlist, blockquote, |, pastetext, pasteword, |, undo, redo, |, link, unlink, code, fullscreen';
          }

          $('textarea.html-textarea').tinymce({
            script_url: '/assets/goldencobra/html_editors/tinymce_v3/tinymce_v3.js',
            language: 'de',
            mode: 'textareas',
            theme: 'advanced',
            theme_advanced_buttons1: buttons,
            theme_advanced_buttons2: '',
            theme_advanced_buttons3: '',
            theme_advanced_toolbar_location: 'top',
            theme_advanced_toolbar_align: 'center',
            theme_advanced_resizing: false,
            relative_urls: true,
            convert_urls: false,
            theme_advanced_blockformats: tags,
            plugins: 'fullscreen, autolink, paste',
            dialog_type: 'modal',
            paste_auto_cleanup_on_paste: true
          });
        }
      });
    }
  });
}
