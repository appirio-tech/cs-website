// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(function() {
  
  $.fn.defaultValue = function(value) {
    var self = $(this);
    self.focus(function() {
      if (self.val() == value) {
        self.val("");
      }
    });
    self.blur(function() {
      if (self.val() == "") {
        self.val(value);
      }
    });
  }
  
  $(".members-search").defaultValue('search members');
  $(".challenges-search").defaultValue('search challenges');
});