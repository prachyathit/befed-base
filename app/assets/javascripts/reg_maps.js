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
        var map = new google.maps.Map(document.getElementById('map'));
        map.setZoom(18);
        map.setCenter(result.geometry.location);
      });

      $(".location").bind("geocode:dragged", function(event, latLng){
      var map = new google.maps.Map(document.getElementById('map'));
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
       var options = {
         enableHighAccuracy: true,
         timeout: 5000,
         maximumAge: 0
       }
       $(".location-arrow-wrapper").addClass("hide");
       $(".spinning-icon-wrapper").removeClass("hide");
       $('#map-container').slideDown();
       navigator.geolocation.getCurrentPosition(function(position){
         var pos = {
           lat: position.coords.latitude,
           lng: position.coords.longitude
         }
         var map = new google.maps.Map(document.getElementById('map'));
         marker = new google.maps.Marker({position: pos, title: 'BeFed Map', map: map});
         map.setCenter(pos);
         map.setZoom(17);
         marker.setPosition(pos);
         $.ajax({
           url: "http://maps.googleapis.com/maps/api/geocode/json?latlng=" + position.coords.latitude + "," + position.coords.longitude,
           success: function(result) {
             $(".location-arrow-wrapper").removeClass("hide");
             $(".spinning-icon-wrapper").addClass("hide");
             $('.location').val(result.results[0].formatted_address);
           }
         })
       }, null, options);
     });

     autocomplete = new google.maps.places.Autocomplete(document.getElementsByClassName("location")[0]);
     autocomplete.addListener('place_changed', function() {
       var place = autocomplete.getPlace();
       $('.latitude').val(place.geometry.location.lat());
       $('.longitude').val(place.geometry.location.lng());
       var map = new google.maps.Map(document.getElementById('map'));
       marker = new google.maps.Marker({position: place.geometry.location, title: 'BeFed Map', map: map});

       map.setCenter(place.geometry.location);
       map.setZoom(17);
       marker.setPosition(place.geometry.location);
     });

   });
