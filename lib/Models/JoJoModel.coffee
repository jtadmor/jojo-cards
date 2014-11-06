###

JoJo object:

Contains the information for each particular jojo

###

JoJo = (params) -> 

	# Defaults 
	props = 
		inputs: []
		entries: []
		numEntriesEver: 0
		sortBy: false
		rateIt: false
		titleBy: false
		groupBy: false
	

	# Combine defaults and params
	$.extend(true, props, params)

	# Create JoJo
	for prop in props 
		@prop = props[prop]

# JoJo METHODS:
# . displayEntries
# . createTemplate
# . showForm

# Display Entries: 
# @param: Flexible type, could be string, array, object... 
# 	1. Compile the HTML into a template
# 	2. Based on param, determine which entries should be displayed
# 	3. Calls .renderEntry with each of those entries
JoJo.prototype.displayEntries = (param) ->


	# Handle string arguments
	if typeof param is 'string'
		
		switch param 
			# If 'all', show all!
			when 'all'
			# If there is a sortBy, sort all the entries before showing them	
				if @sortBy then @entries = _.sortBy(@entries, @sortBy)
				# in the special case of sorting by rating, give all entries without a rating a rating of 0, then sort and reverse, (so it goes from highest to lowest rating)
				if @sortBy is 'rating' then @entries = @entries.reverse()

				for i in @entries
					# render and display entry
					@entries[i].renderMe(@entryTemplate)
					@entries[i].displayMe()

			# Show last (on entry sumission)
			when 'last'
				@entries[@entries.length - 1].renderMe(@entryTemplate)
				@entries[@entries.length - 1].displayMe()

			# Show a random entry
			when 'random'
				# Shuffle the array of entries rather than just getting one random one, allowing for addition of a slideshow or forward / backward features
				@entries = _.shuffle(@entries)

				# Grab the first
				@entries[0].renderMe(@entryTemplate)
				@entries[0].displayMe()

	# If we have an object, look through the entries and see if they have matching key: value pairs
	else if typeof param is 'object' 
		
		# _.where will find all entries that contain the key: value pair(s) in the param object
		tobedisplayed = _.where(@entries, param)
		
		tobedisplayed.forEach( (el) -> 
			el.displayMe()
			null
		)

	null
	# Replace with actual return statement here


###
# Create Template:
JoJo.prototype.createTemplate = () ->

	var wrapperStart = '<div class="row entryContainer"><div class="small-12 medium-8 medium-centered large-6 large-centered columns">';

	var wrapperEnd = '</div>';

	var toolbox = '<div class="small-12 medium-8 medium-centered large-6 large-centered columns"><div class= "icon-bar six-up"><a type="button" class="deleteEntry"><i class="fi-x"></i></a>';

	if (this.rateIt) {
		toolbox += '<a href="#" class="1rating"><i class="fa fa-star-o"></i></a><a href="#" class="2rating"><i class="fa fa-star-o"></i></a><a href="#" class="3rating"><i class="fa fa-star-o"></i></a><a href="#" class="4rating"><i class="fa fa-star-o"></i></a><a href="#" class="5rating"><i class="fa fa-star-o"></i></a>';
	}

	toolbox += '</div></div></div>'

	var entrydisplays = '';

	this.inputs.forEach( function(inp) {
		entrydisplays += inp.name + ': {{[' + inp.name + ']}}\n';
	});
	
	this.entryTemplateHTML = wrapperStart + entrydisplays + wrapperEnd + toolbox;
};

# Show Form:
# params: Optional parameter of the container, as jQuery object to append the form to, if nothing is given, .formContainer is used
# Takes the form HTML, wraps it in the form divs, foundations it, and appends it to the DOM	
JoJo.prototype.showForm = (container) -> 

	# Get the target, create the form element, append it to the target
	var target = container || $('.formContainer');
	var formEl = $('<form id="entryForm" class="entryForm" data-abide></form>').append(this.formHTML);
	target.append(formEl);

	# Run foundation on the form and attach the event handlers
	$('#entryForm').foundation();
	eventSubmitForm();

###