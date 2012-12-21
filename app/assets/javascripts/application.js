// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//= require jquery
//= require rails
//= require facebox
//= require cobot_client/easyxdm
//= require_self

jQuery(function($) {
  window.setTimeout(function() {
    $('.flash').fadeOut();
  }, 5000);

  $('a[rel*=facebox]').facebox()

  $('.embed').live('focus', function(e) {
    var input = this;
    window.setTimeout(function() {
      input.select();
    }, 1);
  });

});
