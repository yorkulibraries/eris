jQuery(function($){

	
   $('ul#feeds').sortable({
	    axis: 'y',
	    handle: '.handle',
	 	update: function() {
	       $.post($(this).data('update-url'), $(this).sortable('serialize'));
	 	}	    
	 });
	


});


  