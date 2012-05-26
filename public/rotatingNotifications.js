/**
	jQuery plugin for displaying rotating notifications in cloudspokes page
	@author Antenna
	
	How to use:
	----------
	After including this script, please select the container where notifications will appear.
	Container can be :
		- document.body : notifications come at extreme right and peak top 
		- div/span etc : In case of cloudspokes layout a div ID = "wrapper", is used that is 960 px in width, notifications should position
						 themselves on this div. 
		
	So this plugin gives the core flexiblity to use any HTML element to act as container.

	Ex. 
		// shows notifications rotating with default 3 seconds lag
		$('#wrapper').rotatingNotifications();
	
	Settings/Options :
	------------------
	One can pass various options, to change the plugin default behavior 
	for ex. don't show notifications with lag of 3 seconds, instead do it every 2 seconds

		$('#wrapper').rotatingNotifications({changeInterval : 2000}); 

	Other similar settings include:
		sourceURL : this default to a local JSON file named "notifications.json", 
					please change it to some URL on your server in this file only or via 
					options
		
		anchorClass : Anchor CSS class, if your designer has better css class, you can pass it in options

		anchorTarget : By default, the notification links open in new window you can change it to open differently 							
*/
(function( $ ) {
  $.fn.rotatingNotifications = function(options) {
  	var $this = $(this);

     // Create some defaults, extending them with any options that were provided
    var settings = $.extend( {
       /* Un comment the line below, to the server url desired, I can't make it work
        because of cross domain issues	*/
       //'sourceURL'         : 'http://node-demo-devserver.herokuapp.com/notifications',             
      'sourceURL'         : './notifications.json',      
      /*
       how frequently the notifications should change, 
       one can change it to 0, in case you want to show the notification only once
       */
      'changeInterval'	  : 3000,
      /*
      	Anchor CSS class, if your designer has better css class, you can pass it in options
      */
      'anchorClass'		  : 'rotatingNotificationsAnchor',
      /* 
      	By default, the notification links open in new window you can change it to open differently
      */
      'anchorTarget'	  : '_blank'      
    }, options);



    $.getJSON(settings.sourceURL, function(data) {
      // bad bad server, do nothing
      if (!data || data.length == 0) return false;

      var containerOffSet = $this.offset();
      var containerWidth = containerOffSet.left + $this.width();	  
	  var topRightDiv = $('<div />')
	  						.css('position', 'absolute')
	  						.css('top', containerOffSet.top)	  												  						
	  						.css('right', $(document).width() - containerWidth)
	  						.css('padding' , '10px')
	  						.appendTo($this);
	  
	  /* 
	  	used to avoid display of duplicate notifications,
	  	because same random number might come in certain cases.		
	  */ 
	  var previousIdx = -1;
	  		  						
      function startNotifications() {
      		// randomly pick any item
			var itemIdx = Math.floor((Math.random()* data.length));
			// show if we have a new item this time, random numbers come same many times
			if (previousIdx != itemIdx) {
				var item = data[itemIdx]; 		
				// clear the previous anchor html
				topRightDiv.html('');

		  		var notificationAnchor = $('<a href = ' + item.url +' target="' + settings.anchorTarget + '">' + item.text +'</a>')
		  									.hide()
		  									.addClass(settings.anchorClass)
		  									.appendTo(topRightDiv)
		  									.slideDown('slow');
		  		
		  		previousIdx = itemIdx;
		  	}
	  		
	  		setTimeout(startNotifications, settings.changeInterval);		  		
      }

      // start timer only if their is a change interval
      if (settings.changeInterval > 0) {
      	setTimeout(startNotifications, settings.changeInterval);	
      } else {
      	// show the first notification
      	startNotifications();
      }
	});


  };
})( jQuery );