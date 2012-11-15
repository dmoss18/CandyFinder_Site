$(document).ready(function() {
function AppViewModel() {
    var self = this;

    self.test = "stuff";
    self.locFilter = ko.observable(); 
    self.places = ko.observableArray([]);
    self.location = ko.observable();
    self.location.subscribe(function() {
	self.hasLocation(true);
    });
    self.hasLocation = ko.observable(false);

    this.getFilteredResults = function() {
	self.places.removeAll();
	$.ajax({
	  url : '/locations/filtered_google_places_data?filter=' + self.locFilter() + '&lat=' + self.location().lat() + '&lon=' + self.location().lon(),
	  success : function(results) {
		if(results) {
		  $.each(results, function(index, result) {
			self.places.push(new Place(result, self));
		  });
		}
	  },
	  error : function() {
		alert("There was an error.  Sorry");
	  }
	});
    };

    this.getLocation = function() {
	$.ajax({
	  url : '/locations/' + $('#locId').val(),
	  type : 'GET',
	  dataType : 'json',
	  success : function(location) {
		self.location(new Location(location));
	  },
	  error : function(data) {
		alert("Error getting location info.  Sorry");
	  }
	});
    }

    self.getLocation();

}
 
ko.applyBindings(new AppViewModel());

});

function Place(result, vm) {
  var self = this;

  self.name = result.name;
  self.vicinity = result.vicinity;
  self.reference = result.reference;

  this.submitPlace = function() {
	$.ajax({
	  url : '/locations/populate_google_places_data',
	  type : 'POST',
	  dataType : 'JSON',
	  data : { 'reference' : self.reference, 'id' : vm.location().id() },
	  success : function(result) {
	    //change location stuff on html page
	    vm.location(new Location(result));
	  },
	  error : function(result) {
	    alert("There was an error submitting.  Sorry");
	  }
	});
  }

}

function Location(data) {
  var self = this;
  self.id = ko.observable(data.id);
  self.lat = ko.observable(data.lat);
  self.lon = ko.observable(data.lon);
  self.name = ko.observable(data.name);
  self.address = ko.observable(data.address);
  self.city = ko.observable(data.city);
  self.state = ko.observable(data.state);
  self.zip = ko.observable(data.zip);
  self.google_id = ko.observable(data.ext_id);
  self.international_phone = ko.observable(data.phone_international);
  self.reference = ko.observable(data.ext_reference);
  self.google_url = ko.observable(data.ext_url);
  self.full_address = ko.computed(function() {
	return self.address() + ' ' + self.city() + ', ' + self.state() + ', ' + self.zip();
  });
}
