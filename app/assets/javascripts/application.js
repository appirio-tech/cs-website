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
  $("#search .field").focus(function() {
    var self = $(this);
    if (self.val() == "search challenges") {
      self.val("");
    }
  }).blur(function() {
    var self = $(this);
    if (self.val() == "") {
      self.val("search challenges");
    }
  });

  // CHANGE THIS TO REQUIRED LENGTH
  var SEARCH_CHARACTER_LIMIT = 30;
  
  $.fn.limit = function(max_length) {
      var self = $(this);
      
      self.keydown(function(e) {      
      text = self.val();
      if (text.length >= max_length) {
        self.val(text.substr(0, max_length));
      }
    });
  };
  
  $("#search .field").limit(SEARCH_CHARACTER_LIMIT);

});