// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//= require jquery
//= require jquery_ujs
//= require facebox
//= require_self

jQuery(function($) {
  $('a[rel*=facebox]').facebox();

  $('.embed').live('focus', function(e) {
    var $input = $(this);
    window.setTimeout(function() {
      $input.select();
    }, 1);
  });

});
