$('#places_filter_button').on('click', get_google_places_data());

function get_google_places_data() {
  var lat = $('#lat').val();
  var lon = $('#lon').val();
  var filter = $('#places_filter').val();

  $.ajax(function() {
    url : '/locations/filtered_google_places_data?filter=' + filter + '&lat=' + lat + '&lon=' + lon,
    
  });

};
