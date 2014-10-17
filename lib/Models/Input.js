// I'm a cheater with a global variable, put this somewhere else when you get more clever
var input_template_source = 
'<label for="{{name}}">{{name}}</label>' +
'{{#each inputs}}'+
'{{if this.value}}<label>/{{if}}' +
'<{{this.field}} if {{this.type}}type="{{this.type}}" {{/if}} name="{{this.name}}" {{if this.value}}value="{{this.value}}"{{/if}} {{if this.required}}required{{/if}}>{{if this.value}}this.value</label>{{/if}}' +
'{{#each this.options}}<option value="{{this.options.value}}">{{this.options.value}}</option>{{/each}}{{/each}}';

var input_template = Handlebars.compile(input_template_source);

// Show render
Input.prototype.renderMe = function() {

	if (!this.element) {
		this.element = input_template(this);
	}
};

var User = function(password) {

	this.password = password;

	this.categories = {};

	this.currentCateg = 'inspirationalQuotes';
};

// Remove this once actual users can be created...
var Me = new User('password');

if (!$.jStorage.get('Me')) {
	$.jStorage.set('Me', Me);
};