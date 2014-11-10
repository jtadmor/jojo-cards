# EVENTS AND HANDLERS FOR CREATING A NEW ENTRY WITHIN THE CURRENT JOJO

# ------------- NEW ENTRY FORM ---------------

# On render, initialize foundation on that sucka
Template.new_entry.rendered = () ->
	$('#entry-form').foundation() 

Template.new_entry.events (

	# Submit the form
	'submit #entry-form': (e) ->
		# Prevent default
		e.preventDefault()

		# Create a new object for the entries database, with properties in the form
		# inputName (' ' replaced with '_'): inputValue
		entry = {}

		# Go through each input container and strip the needed data, then reset the input
		$(e.target).find('.entry-form-input-container').each( ()->
			# Grab the data context 
			data = Blaze.getData(this)

			# If the element is a select, simple input, or textarea, the value should just be input.val()
			if data.element in ["select", "input", "textarea"]
				entry[data.name.replace(/\s/g, '_')] = $(this).find(data.element).val()
				$(this).find(data.element).val('')

			# If the element is a radio, the value is the selected val
			else if data.element.match(/radio/)
				entry[data.name.replace(/\s/g, '_')] = $(this).find('input:checked').val()
				$(this).find('input:checked').prop('checked', false)

			# For a checkbox, value is a comma-separated list of the selected values 
			# (Open to change / user customization later)
			else if data.element.match(/checkbox/)
				checkedValues = []
				$(this).find('input:checked').each( () -> 
					checkedValues.push( $(this).val() )
					$(this).prop('checked', false)
				)
				entry[data.name.replace(/\s/g, '_')] = checkedValues.join(', ')
			)

		# Insert the entry into the EntriesDB object, with a callback that adds the _id of the new entry into the entryIDs array of the current jojo
		EntriesDB.insert({
			jojoId: Session.get('currentJoJo')
			data: entry
		}, 
		(err, _id) ->
			if err then console.log err
			else
				JoJoDB.update(Session.get('currentJoJo'), {$push: {'entries.entryIDs': _id}})
		)

		# Display the most recent post

		# Blaze.renderWithData(...)

		null
)

# -------------- INPUTS ---------------------	

Template.input.helpers(

	# Create the input element
	el: () ->

		# Get the data and merge it with defaults
		defaults = {name: "Input#{Template.currentData().position}", prompt: "Enter a value:", choicesCount: 0, required: "false"}
		data = $.extend(defaults, Template.currentData())
		# If there are choices, turn them into an arra
		if data.choicesCount
			choices = []
			for i in [1..data.choicesCount]
				choices.push data["choices#{i}"]

		# Create the htmlString that will be returned
		htmlString = ''

		# If simple input or textarea
		if data.choicesCount is 0
			htmlString += "<#{data.element} type=#{data.type} required=#{data.required} name=#{data.name}>"

		# If select
		else if data.element is 'select'
			htmlString += "<select required=#{data.required} name=#{name}>"
			htmlString += "<option value='#{choice}'>#{choice}</option>" for choice in choices

		# If checkbox or radio
		else 
			htmlString += "<#{data.element} name='#{data.name}' required=#{data.required} value='#{choice}' id='#{data.name.replace(' ','')}-#{choice}'><label for='#{data.name.replace(' ','')}-#{choice}'>#{choice}</label>" for choice in choices

		# Return the html
		htmlString
)