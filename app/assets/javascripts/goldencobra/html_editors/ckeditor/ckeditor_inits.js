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
  }, 200);

  setTimeout(function () {
    $('textarea.html-textarea').ckeditor();
  }, 700);
}
