// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(function($) {
  window.setTimeout(function() {
    $('.flash').fadeOut();
  }, 5000);
  
  $('.list').tablesorter({
    cssAsc: "sortdown",
    cssDesc: "sortdown",
    cssHeader: "tableheader"
  });
  
  $('#search').keyup(function(){
    $.uiTableFilter($('.list'), $(this).val());
  });
  
  $('.embed').live('focus', function(e) {
    var input = this;
    window.setTimeout(function() {
      input.select();
    }, 1);
  });
  
});