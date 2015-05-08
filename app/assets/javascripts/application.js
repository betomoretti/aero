// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets READTME (https://github.com/sstephenson/sprockets#sprockets-directives) for details
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
//= require spin.min

var ready;

ready = (function() {
	if (window.location.pathname == "/") {
		$('div.dropdown').addClass('index');
	};

	$('form#searchForm').on('submit', function () {
		$('form#searchForm .dropdown').css('border-color','white');
	});

	// Agrega informacion para que valide el select solo despues de que se intento submitear
    $('.searchBtn').on('click', function () {
    	$('form#searchForm .dropdown').css('border-color','red');
    	$('form#searchForm .dropdown').attr('data-require','true');
    });

	// Cambia el action del formulario dependiendo si van a buscarse servicios o circuitos. Toma el valor del select
	$("#option_select").on('change',function(){
			
		var paths = {
			"Service" :      "/search/services",
			"Program" :      "/search/circuits",
			"OutputGroups" : "/search/output_groups",
			"Hotel" : "search/hotels"
		} 
		var value = this.value;

		if ($('form#searchForm .dropdown').attr('data-require') == 'true' && value != "") {
			$('form#searchForm .dropdown').css('border-color','green');
		}else if ($('form#searchForm .dropdown').attr('data-require') == 'true' && value == ""){
			$('form#searchForm .dropdown').css('border-color','red');
		}

		$("#searchForm").attr('action', paths[value]);
	});


	// Autocomplete
    $("#search-input").autocomplete({
		source: function(request, response) {
	        $.ajax({
	            url: '/unique/autocomplete.json',
	            dataType: "json",
	            data: {
	                term : request.term
	            },
	            success: function(data) {
	                response(data);
	            }
	        });
	    },
		minLength: 3,
		focus: function( event, ui ) {
	        $( "#search-input" ).val( ui.item.name );
	        
	        return false;
	    },
		select: function( event, ui ) {
			$( "#search-input" ).val( ui.item.name );
	        $( "#type_search" ).val( ui.item.type );
	        $( "#id_search" ).val( ui.item.id );
	 
	        return false;
	    }
    }).autocomplete( "instance" )._renderItem = function( ul, item ) {
      return $( "<li>" ).append( "<a>" + item.name + "</a>" ).appendTo( ul );
    };
});

$(document).ready(ready);
$(document).on('page:load', ready);