// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//= require jquery
//= require jquery_ujs
//= require_self

jQuery(function($) {
  $(document).on('focus', '.embed', function(e) {
    var $input = $(this);
    window.setTimeout(function() {
      $input.select();
    }, 1);
  });
});
