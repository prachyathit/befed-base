$(document).ready(function() {
  ////Hide all map modals/////
  $("#map-container").hide();
  $("#map-modal").hide();
  $("#map-modal-edit").hide();
  $("#place-modal").hide(); 
  var address_local = $('.location').val();
      var lat_local = $('.latitude').val();
      var lng_local = $('.longitude').val();
  /////Initial Variables//////
  var options = {
    map: "#map",
    mapOptions: {
      streetViewControl: false,
    },
    markerOptions: {
      draggable: true
    },
    types: []
  };
  var geocoded = false;
      
  //////Geocode and Geocomplete//////////    
  $(".location").geocomplete(options).bind("geocode:result", function(event, result){
     //get the value of the result and put it where it is supposed to be
    $('.latitude').val(result.geometry.location.lat());
    $('.longitude').val(result.geometry.location.lng());
    var map = $(".location").geocomplete("map");
    map.setZoom(16);
    map.setCenter(result.geometry.location);
    geocoded = true;
  });

  //////Drag Marker Event///////
  $(".location").bind("geocode:dragged", function(event, latLng){
  var map = $(".location").geocomplete("map");
    map.panTo(latLng);
    var geocoder = new google.maps.Geocoder();
    geocoder.geocode({'latLng': latLng }, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      if (results[0]) {
        $('.location').val(results[0].formatted_address);
        $('.latitude').val(latLng.lat());
        $('.longitude').val(latLng.lng());
      }
    }
    });
  });
  $(".switch-map").on("click", function() {
    $("#place-modal").modal("hide");
    $("#map-modal").modal("show");
    
  });
  /////Show map modal, show the map if the location already existed////////
  $(".showplace").on("click", function() {
    $("#place-modal").modal("show");
  });

  /////Show map modal, show the map if the location already existed////////
  $(".showmap").on("click", function() {
    
    $("#map-modal").modal("show");
    $("#map-modal-edit").modal("show");
    
    // diabled: Prefill bug on non geocode location (places, establishment) geocomplete find results in multiple results which are incorrect.
    // if (address_local && !geocoded) { 
    if (false) {
    
      setTimeout(function() {
      $('#map-container').slideDown();
      var map = $(".location").geocomplete("map");
        
        // google.maps.event.trigger(map, 'resize');
        
        
      
      }, 300);
    }
  });

  //////Location chage event//////
  $(".location").on("change", function() {
    $("#map-modal").modal("show")
    $("#map-modal-edit").modal("show")
    $('#map-container').slideDown();
    google.maps.event.trigger(map, 'resize');
  });

    /////Auto locate//////
  $(".location-arrow-wrapper").click(function() {
   var timeoutOptions = {
     enableHighAccuracy: true,
     timeout: 5000,
     maximumAge: 0
   }
  
   $(".location-arrow-wrapper").addClass("hide");
   $(".spinning-icon-wrapper").removeClass("hide");
   $('#map-container').slideDown();
   
   if (navigator.geolocation) {
     navigator.geolocation.getCurrentPosition(function(position){
      var map = $(".location").geocomplete("map");
       google.maps.event.trigger(map, 'resize');
       $.ajax({
         url: "https://maps.googleapis.com/maps/api/geocode/json?latlng=" + position.coords.latitude + "," + position.coords.longitude,
         success: function(result) {
           $(".location-arrow-wrapper").removeClass("hide");
           $(".spinning-icon-wrapper").addClass("hide");
           $(".location").geocomplete("find", result.results[0].formatted_address);
         }
       })
     }, function() {
        alert("We can't locate your current location. Please grant a permission in your browser to locate your device");
          $(".location-arrow-wrapper").removeClass("hide");
          $(".spinning-icon-wrapper").addClass("hide");
       }, timeoutOptions);
   } else {
     alert('Error: Your browser doesn\'t support geolocation.')
   }
  });
});
