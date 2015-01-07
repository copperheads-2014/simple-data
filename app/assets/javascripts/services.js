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




// = form_for @service, as: :service, url: "/services/"+@service.slug, method: :put, multipart: true do |f|
//   = f.hidden_field :file, value: "https://#{ENV['S3_BUCKET']}.s3.amazonaws.com/"
//   = f.hidden_field :updating, value: "true"
//   = f.hidden_field :new_version, value: "false"
//   / change to true based on click
//   = f.hidden_field :append, value: "false"
//   / change to true based on click
//   = f.submit "Update", data: { confirm: "NOTE: You are about to make this csv's data available to the public. If you are okay with this, Press OK to continue:" }, class: "form-control btn btn-default", :id => "update-service-button"
