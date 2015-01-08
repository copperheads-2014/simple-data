$(document).ready(function(){
$( "#append-api" ).click( function(event) {
  event.preventDefault();
    if ( $( "#add-info" ).is(":hidden") ) {
      $( "div#add-info" ).slideDown("slow");
      $( "#append-api" ).addClass("hovered");
      $( "#new-api-version" ).removeClass("hovered");
      $('#service_append').attr("value", "true");
        if ( $( '#service_new_version' ).attr("value") == "true" ) {
          $( '#service_new_version' ).attr("value", "false");
        }
    } else {
      $( "div#add-info" ).slideUp();
      $( "#append-api" ).removeClass("hovered");
      $( "#new-api-version" ).removeClass("hovered");
      $('#service_append').attr("value", "false");}
    });
});

$(document).ready(function(){
$( "#new-api-version" ).click( function(event) {
  event.preventDefault();
    if ( $( "#add-info" ).is(":hidden") ) {
      $( "div#add-info" ).slideDown("slow");
      $( "#new-api-version" ).addClass("hovered");
      $( "#append-api" ).removeClass("hovered");
      $('#service_new_version').attr("value", "true")
        if ( $( '#service_append' ).attr("value") == "true" ) {
          $( '#service_append' ).attr("value", "false");
        }
    } else {
      $( "div#add-info" ).slideUp();
      $( "#new-api-version" ).removeClass("hovered");
      $( "#append-api" ).removeClass("hovered");
      $('#service_new_version').attr("value", "false");}
    });
});
