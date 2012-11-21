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
//= require jquery-ui
//= require jquery_ujs
//= require goldencobra/jquery.tools.min.js
//= require goldencobra/moment

$(document).ready(function(){

  moment.weekdaysMin = ["So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"];

  // Trigger display of widgets. If widget has offline_times set show
  // alternative content instead.
  $('[data-offline-active=true]').each( function(index, element){
    var days = $(element).attr('data-time-day');
    var start_time = parseInt($(element).attr('data-time-start'));
    var end_time = parseInt($(element).attr('data-time-end'));

    var cur_day = moment().format('dd');
    var cur_time = parseInt(moment().format('Hmm'));

    var start_date = parseInt($(element).attr('data-date-start'));
    var end_date = parseInt($(element).attr('data-date-end'));
    var cur_date = parseInt(moment().format('YYYYMD'));

    //Ausgabe wenn start und enddatum nicht gesetzt sind
    if ($(element).attr('data-date-start').length == 0 && $(element).attr('data-date-end').length == 0){
      if ((days.indexOf(cur_day) != -1) && ((start_time < cur_time) && (cur_time < end_time))) {
        // Widget muss ausgeblendet werden
        $(element).addClass("hidden");
        $(element).next("[data-id="+ $(element).attr('data-id') + "]").removeClass("hidden");
      }
    }

    //Ausgabe wenn start und enddatum gesetzt sind
    if ($(element).attr('data-date-start').length > 0 && $(element).attr('data-date-end').length > 0 && start_date <= cur_date && end_date >= cur_date){
      if ((days.indexOf(cur_day) != -1) && ((start_time < cur_time) && (cur_time < end_time))) {
        // Widget muss ausgeblendet werden
        $(element).addClass("hidden");
        $(element).next("[data-id="+ $(element).attr('data-id') + "]").removeClass("hidden");
      }
    }
  });

  console.log($('.goldencobra_widget.hidden').length);
  $('.goldencobra_widget.hidden').remove();
  console.log($('.goldencobra_widget.hidden').length);

});