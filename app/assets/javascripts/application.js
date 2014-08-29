// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
// require jquery
// require jquery_ujs
// require turbolinks
// require_tree .

 
//= require minified/jquery-1.11.0.min
//= require minified/jquery.easydropdown.min
//= require minified/jquery.backstretch.min
//= require minified/jquery.easytabs.min
//= require bootstrap
//= require jquery-ui/autocomplete

var ready;
ready = (function() {
  	$.get( '/unique/autocomplete.json', function( data ) {
	    $("#search-input").autocomplete({
			source: data
		});
	});

});

$(document).ready(ready);
$(document).on('page:load', ready);