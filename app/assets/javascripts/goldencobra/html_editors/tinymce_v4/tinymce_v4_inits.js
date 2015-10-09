function initTinyMCEv4() {
  var jsTag = document.createElement('script');
  jsTag.type = 'text/javascript';
  jsTag.src = '/assets/goldencobra/html_editors/tinymce_v4/jquery.tinymce_v4.js';
  document.getElementsByTagName('head')[0].appendChild(jsTag);

  var tags = '';
  var buttons = '';

  $.ajax({
    type   : 'GET',
    url    : '/api/v2/setting_string',
    data   : { 'setting_key': 'goldencobra.html_textarea.tinymce_v4_setup_tags' },
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
        data   : { 'setting_key': 'goldencobra.html_textarea.tinymce_v4_setup_buttons' },
        success: function (data) {
          if (data && data.indexOf('translation missing') == -1) {
            // return value of setting key
            buttons = data;
          } else {
            // set standard
            buttons = 'insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image';
          }

          $('textarea.html-textarea').tinymce({
            script_url: '/assets/goldencobra/html_editors/tinymce_v4/tinymce_v4.js',
            language: 'de',
            selector: 'textarea',
            theme: 'modern',
            toolbar: buttons,
            relative_urls: true,
            convert_urls: false,
            // formats: tags,
            plugins: [
              "advlist autolink lists link image charmap print preview anchor",
              "searchreplace visualblocks code fullscreen",
              "insertdatetime media table contextmenu paste"
            ],
            width: '79.7%',
            dialog_type: 'modal',
            paste_auto_cleanup_on_paste: true
          });
        }
      });
    }
  });
}
