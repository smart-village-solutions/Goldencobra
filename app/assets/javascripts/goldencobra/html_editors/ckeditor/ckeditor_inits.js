/* globals document, $ */
/* exported initCKEditor */

function initCKEditor() {
  // load ckeditor script first
  var ckeditorJsTag = document.createElement('script');
  ckeditorJsTag.type = 'text/javascript';
  ckeditorJsTag.src = '/assets/goldencobra/html_editors/ckeditor/ckeditor.js';
  ckeditorJsTag.async = false;
  ckeditorJsTag.onload = function() {
    // load jquery adapter script after ckeditor script
    var adapterJsTag = document.createElement('script');
    adapterJsTag.type = 'text/javascript';
    adapterJsTag.src = '/assets/goldencobra/html_editors/ckeditor/adapters/jquery.js';
    adapterJsTag.async = false;
    adapterJsTag.onload = function() {
      // bind ckeditor on textarea elements and fix css
      var $textareaHtml = $('textarea.html-textarea');
      $textareaHtml.ckeditor();
      $textareaHtml.parent('li').css('overflow', 'hidden');
    };
    document.getElementsByTagName('head')[0].appendChild(adapterJsTag);
  };
  document.getElementsByTagName('head')[0].appendChild(ckeditorJsTag);
}
