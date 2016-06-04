$(document).ready(function() {
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
      $(".location").geocomplete(options).bind("geocode:result", function(event, result){
         //get the value of the result and put it where it is supposed to be
        $('.latitude').val(result.geometry.location.lat());
        $('.longitude').val(result.geometry.location.lng());
        var map = $(".location").geocomplete("map");
        map.setZoom(18);
        map.setCenter(result.geometry.location);
      });

      $(".location").bind("geocode:dragged", function(event, latLng){
      var map = $(".location").geocomplete("map");
        map.panTo(latLng);
        var geocoder = new google.maps.Geocoder();
        geocoder.geocode({'latLng': latLng }, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
          if (results[0]) {
            $('.location').val(results[0].formatted_address);
            $('.longitude').val(results[0].geometry.location.lat());
            $('.latitude').val(results[0].geometry.location.lng());
          }
        }
        });
      });

      $("#map-container").hide();
      $(".location").on("change", function() {
        $('#map-container').slideDown();
        google.maps.event.trigger(map, 'resize');
     });



     $(".location-arrow-wrapper").click(function() {
       var timeoutOptions = {
         enableHighAccuracy: true,
         timeout: 5000,
         maximumAge: 0
       }
       $(".location-arrow-wrapper").addClass("hide");
       $(".spinning-icon-wrapper").removeClass("hide");
       $('#map-container').slideDown();
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
       }, timeoutOptions);
     });

   });
