$(document).ready(function() {
function AppViewModel() {
    var self = this;

    var candy = $('#candy-instance');
    self.title = ko.observable(candy.data('title'));
    self.subtitle = ko.observable(candy.data('subtitle'));
    self.sku = ko.observable(candy.data('sku'));
    self.description = ko.observable(candy.data('description'));
    self.alias = ko.computed(function() {
	return self.title() + self.subtitle() + self.description();
    }, self);
}
 
ko.applyBindings(new AppViewModel());

});
