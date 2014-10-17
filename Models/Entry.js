/*

Entry is the prototype for an individual entry. 
@params: At minimum, it should have a unique ID and a reference to the jojo it is a part of. The last paramater is an arbitrary object, containing entry-specific form data and, possibly, additional information about displaying, grouping, ranking, and combining the entry.

*/

var Entry = function(jojo, id, params) {

	// Create jojo and id
	this.jojo = jojo;
	this.id = id;

	// Defaults
	var props = {};

	// Combine
	$.extend(true, props, params);

	// Create Entry
	for (var prop in props) {
		this[prop] = props[prop];
	}

};