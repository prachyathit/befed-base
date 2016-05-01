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

     autocomplete = new google.maps.places.Autocomplete(document.getElementsByClassName("location")[0]);
     autocomplete.addListener('place_changed', function() {
       var map = $(".location").geocomplete("map");
       var place = autocomplete.getPlace();
       $('.latitude').val(place.geometry.location.lat());
       $('.longitude').val(place.geometry.location.lng());
       marker = new google.maps.Marker({position: place.geometry.location, title: 'Hi', map: map});
       map.setCenter(place.geometry.location);
       map.setZoom(17);
       marker.setPosition(place.geometry.location);
     });

   });
