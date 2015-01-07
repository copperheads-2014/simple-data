// = require jquery
// = require jquery_ujs
//= require jquery-ui
//= require_tree .
//= require bootstrap
//= require bootstrap-sprockets
//= require jquery.fileupload

$(document).ready(function(){
  $('.col-md-4').hide();
  $('.dropdown-toggle').dropdown();
  $('[data-toggle="tooltip"]').tooltip();
});
$(document).ready(function(){
$( ".fa-cog" ).hover(
  function() {
    $( this ).addClass( "fa-spin" );
    console.log("happened")
  }, function() {
    $( this ).removeClass( "fa-spin" );
  });
});

$(document).ready(function(){
$( ".displayer" ).click( function(event) {
  event.preventDefault();
  var target = $( this ).attr("id")
  if ( $( "ul#"+target ).is(":hidden") ) {
    $( "ul#"+target ).slideDown("slow");
    $( this ).html("(close)")
  } else {
    $( "ul#"+target ).slideUp();
    $( this ).html("(expand)");}
  });

  var delay = 3600;
  $('.col-md-4').each(function(index) {
    $(this).fadeIn(delay);
    delay = delay + 2000;
  });
});

