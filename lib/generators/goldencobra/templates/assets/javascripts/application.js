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
//= require jquery
//= require jquery_ujs
//= require bootstrap.min

// löschen von zusätzlichen navigationselementen
$(function(){
	$("ul.ul-main-nav li").siblings("li").find(".navigtion_link_imgage_wrapper, .navigtion_link_description_title, .navigtion_link_description, .navigtion_link_call_to_action_name").remove();
	$("ul.ul-footer-nav li").siblings("li").find(".navigtion_link_imgage_wrapper, .navigtion_link_description_title, .navigtion_link_description, .navigtion_link_call_to_action_name").remove();
});

// bookmark seite
function bookmark(url, title) {
  var url = url || location.href;
  var title = document.title;

  // Internet Explorer
  if(document.all) {
    window.external.AddFavorite(url, title);
  }
  // Firefox
  else if(window.sidebar) {
    window.sidebar.addPanel(title, url, "");
  }
  // Opera
  else if(window.opera && window.print) {
    this.title = title;
  }
  // Safari
  else {
    alert("Press " + (navigator.userAgent.toLowerCase().indexOf("mac") != - 1 ? "Command/Cmd" : "CTRL") + " + D to bookmark this page.");
  }
}