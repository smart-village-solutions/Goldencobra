// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//

$(function() {
  $('#get-locale').click(function(e) {
    e.preventDefault();
    $.ajax({
      type   : 'GET',
      url    : '/api/v2/locale_string',
      data   : {'locale_key': 'test.ajax'},
      success: function(data) {
        // output return in div
        $('#locale-container').text(data);
        // call origin link href after ajax
        //window.location.href = linkTo;
      }
    });
  });
});