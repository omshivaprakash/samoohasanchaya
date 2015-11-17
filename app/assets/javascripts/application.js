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
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
// require turbolinks
//= require jquery.validate
//= require highcharts
//= require jquery.ime
//= require jquery.ime.selector
//= require jquery.ime.preferences
//= require jquery.ime.inputmethods
//= require_tree .


$( document ).ready( function () {
	// Kannada ime enabled for form 
	$( '.kan-ime' ).ime();

// validatin added for book translation form
$("#new_fuel_translation").validate({
	rules:{

		"fuel_translation[name]":
		{
			required: true
		}
	},
	messages:{
		"fuel_translation[name]":
		{
			required: "ದಯವಿಟ್ಟು ಪದವನ್ನು ಬೆರಳಚ್ಚು ಮಾಡಿ"
		}
	}
});


// Vote button 
$(".vote-link").click(function(){

	var x = document.getElementsByClassName("vote on");
	var i;
	for (i = 0; i < x.length; i++) { 
		x[i].className = "vote off";
	}
	$( "span", this ).addClass( "vote on" );
 // $(this).find(".vote").className = "vote on";
});
});