/* globals document, setTimeout, $ */
/* exported initCKEditor */

function initCKEditor() {
  var jsTag = document.createElement('script');
  jsTag.type = 'text/javascript';
  jsTag.src = '/assets/goldencobra/html_editors/ckeditor/ckeditor.js';
  document.getElementsByTagName('head')[0].appendChild(jsTag);

  setTimeout(function () {
    jsTag = document.createElement('script');
    jsTag.type = 'text/javascript';
    jsTag.src = '/assets/goldencobra/html_editors/ckeditor/adapters/jquery.js';
    document.getElementsByTagName('head')[0].appendChild(jsTag);
  }, 500);

  setTimeout(function () {
    var $textareaHtml = $('textarea.html-textarea');
    $textareaHtml.ckeditor();
    $textareaHtml.parent('li').css('overflow', 'hidden');
  }, 1000);
}
