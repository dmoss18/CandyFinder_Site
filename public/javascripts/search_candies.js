$(document).ready(function() {
function AppViewModel() {
    var self = this;

    self.candyFilter = ko.observable(); 
    self.candies = ko.observableArray([]);

    this.getFilteredResults = function() {
	self.candies.removeAll();
	$.ajax({
	  url : '/candies/name/' + self.candyFilter(),
	  dataType : 'json',
	  success : function(results) {
		if(results) {
		  $.each(results, function(index, result) {
			self.candies.push(new Candy(result, self));
		  });
		}
	  },
	  error : function() {
		alert("There was an error.  Sorry");
	  }
	});
    };

}
 
ko.applyBindings(new AppViewModel());

});

function Candy(result, vm) {
  var self = this;

  self.id = result.id;
  self.title = result.title;
  self.subtitle = result.subtitle;
  self.sku = result.sku;
  self.description = result.description;
  self.alias = result.alias;

}
