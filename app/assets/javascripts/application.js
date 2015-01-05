// = require jquery
// = require jquery_ujs
//= require jquery-ui
//= require_tree .
//= require bootstrap
//= require bootstrap-sprockets
//= require jquery.fileupload

$(document).ready(function(){
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
$( ".displayer" ).click( function() {
  $( this.ch ).removeClass( "hidden" );
  $( this ).addClass( "hidden");
  console.log("happened");
  });
});

$(document).ready(function(){
$( ".hider" ).click( function() {
  $( '.hideable' ).addClass( "hidden" );
  $( ".displayer" ).removeClass( "hidden" );
  console.log("happened");
  });
});
