$(function () {
  var editor = '';

  $.ajax({
    type   : 'GET',
    url    : '/api/v2/setting_string',
    data   : { 'setting_key': 'goldencobra.html_textarea.editor' },
    success: function (data) {
      if (data && data.indexOf('translation missing') == -1) {
        // return value of setting key
        editor = data;
      } else {
        // set standard
        editor = 'tinymce-v3';
      }

      switch (editor) {
        case 'tinymce-v3':
          initTinyMCEv3();
          break;
        case 'tinymce-v4':
          initTinyMCEv4();
          break;
        case 'ckeditor':
          initCKEditor();
          break;
        default:
          initTinyMCEv3();
      }
    }
  });
});
