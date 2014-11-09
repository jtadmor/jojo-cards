# ------------ CREATE FORM MODAL -------------

Template.create_form.events(
	# Save the data from the model form
	'click #save-form': () ->
		# Grab the data elements from each input and save them under the current jojo
		$('.display-only').each(()->
			JoJoDB.update({_id: Session.get('currentJoJo')}, { $push: {'form.inputs': $(this).data()} })
		)

		# Grab the legend
		JoJoDB.update({_id: Session.get('currentJoJo')}, {$set: {'form.legend': $('#legend-input').val()}})

		# Close the modal and empty it
		$('#form-edit-modal').empty().foundation('reveal','close')
)

Template.create_form.helpers(
	# Creating the touchable input Toolbar (unless it is already there)
	# Each clickable has properties 'action' of 'append' or 'trash', 'input' representing the html object, and 'icon' the fa-icon picture
	touchableInput: () ->
		unless $('.touchable-input').length
			[ { action: 'append', input: 'input', icon: 'font' }, 
			{	action: 'append', input: 'textarea', icon: 'pencil-square-o'}, 
			{	action: 'append', input: 'input type="radio"', icon: 'dot-circle-o'}, 
			{	action: 'append', input: 'input type="checkbox"', icon: 'check-square-o'},
			{ action: 'append', input: 'select', icon: 'list-alt'},
			{ action: 'trash', input: '', icon: 'trash'} ]

	# Create 12 input containers
	inputContainer: () ->
		[0..11]

	# Hide the toolbar when editing an input
	editingInput: () ->
		Session.get('createForm-activity')?.match(/editing/)
)

# ---------- INPUT CONTAINERS -----------

Template.input_container.helpers(
	# Set 'empty-active' or 'full-active' based on whether the container has a child element and what the activity is
	isActive: () ->
		# Get which template instance we are working with
		current = Template.currentData()
		
		# Return 'active' as appropriate
		if Session.get('createForm-activity')?.match(/append/)
			'empty-active' if not $(".input-container").eq(current).children().length
		else if Session.equals('createForm-activity', 'trash')
			'full-active' if $(".input-container").eq(current).children().length
)

Template.input_container.events(
	# Render the model input in an empty-active input-container 
	'click .empty-active': (e, template) ->
		
		data = Blaze.getData($('.active-icon')[0])

		# Get the data from active icon
		input = data.input

		# Create the element using the active icon
		el = '<'+ data.input + '>'
		
		# Get the id of the parent input container
		ind = Blaze.getData(e.target)
		
		# Render the model input
		Blaze.renderWithData(Template.model_input, {el: el, ind: ind, input: input}, e.target)

		# Update activity
		Session.set('createForm-activity','')

	# Trash the model input in a full-active input-container, clear the data attributes
	'click .full-active': (e, template) -> 
		$(e.currentTarget).empty()
		Session.set('createForm-activity','')
)

# ----------- TOUCHABLE INPUTS -------------

Template.touchable_input.helpers(
	# Set 'active-icon' class if the given Template's data matches the activity
	isActive: () ->
		activity = Template.currentData().action + ' ' + Template.currentData().input
		'active-icon' if Session.equals('createForm-activity', activity.trim())
)

Template.touchable_input.events(
	# Clicking a touchable-input changes the createForm-activity to 'append ___' or 'trash' 
	'click .touchable-input': (e) ->
		data = Blaze.getData(e.target)
		activity = data.action + ' ' + data.input
		Session.set('createForm-activity', activity.trim())
)

# ------------ MODEL INPUTS -------------------

Template.model_input.helpers (
	# Set 'being-edited' if the activity is 'editing [index]' and the index matches
	beingEdited: () ->
		if Session.get('createForm-activity')?.match(/editing/)
			'being-edited' if Session.get('createForm-activity')?.match(/\d+/g)[0] is Template.instance().data.ind.toString()
)			

Template.model_input.events (
	### 
	On click:
	1. Prevent default
	2. Change the activity to reflect the currently edited input
	3. Render the tab menu for editing the input. 
	4. If already editing what you clicked on or if trashing an input, do nothing.
	###
	'click .display-only': (e, template) ->
		e.preventDefault()

		unless $(e.currentTarget).hasClass('being-edited') or Session.get('createForm-activity', 'trash')
			# Get the index and set the activity
			current = template.data.ind
			Session.set('createForm-activity', "editing #{current}")

			# Get the data context for the tab menu
			Meteor.setTimeout(() -> 
				data = $('#being-edited').data('element')
				input = data is 'input'
				addOptions = data is 'select' or data.match(/radio|checkbox/)

				# Render the tab menu, destroying any that might be there now
				Blaze.renderWithData(Template.editing_input_tab_menu, {input: input, addOptions: addOptions}, $('#tab-menu-holder')[0])
				null
			, 50)
)


# ------------- EDITING INPUT TAB MENU ------------------

### 
On rendering the template:
1. Initialize foundation so that the tabs work properly
2. Set up an autorun that will destroy it anytime the current activity Session variable is changed
###

Template.editing_input_tab_menu.rendered = () ->

	# Intialize foundation
	$('#tab-menu-holder').foundation()
	
	# Save the view and the index
	temp = this.view
	index = Blaze.getData( $('#being-edited').closest('.input-container')[0] )
	this.autorun( ()->
		# Get the index of the currently being edited input's container

		# Destroy if the Session variable is not equal to editing that one
		if not Session.equals('createForm-activity', "editing #{index}")
			$('#tab-menu-holder').empty()
			# Blaze.remove(temp)
	)

Template.editing_input_tab_menu.events(

	# Grab prompt, name, default value from the respective inputs
	'keyup #set-input-prompt, keypress #set-input-prompt': (e) ->
		$('#being-edited').attr('data-prompt', $(e.target).val())
		$('#being-edited').find('label').text($(e.target).val())

	'keyup #set-input-name, keypress #set-input-name': (e)->
		$('#being-edited').attr('data-name', $(e.target).val())

	'keyup #set-input-default, keypress #set-input-default': (e)->
		$('#being-edited').attr('data-default', $(e.target).val())

	# Toggle input required
	'change #set-input-required': (e)->
		$('#being-edited').attr('data-required', e.target.checked)

	# Add options to radio, checkbox, select
	'keypress #add-input-choice': (e) ->
		domEl = $('#being-edited')
		if e.which is 13
			# Update the data field
			if domEl.attr('data-choices-count') then count = Number(domEl.attr('data-choices-count')) + 1 else count = 1
			domEl.attr('data-choices-count', count)
			domEl.attr('data-choices' + count, $(e.target).val())

			# Update the display
			if domEl.attr('data-element') is 'select'
				domEl.find('select').append("<option> #{$(e.target).val()} </option>")
			else
				# Remove the empty radio / checkbox if it's still there
				unless domEl.find('input').attr('value')
					domEl.find('input').remove()
				domEl.append("<#{domEl.attr('data-element')} value=#{count}}><label>#{$(e.target).val()}</label>")

			# Reset the input
			$(e.target).val('')

	# Change the input type
	'change input[name="type"]': (e) ->
		$('#being-edited').attr('data-type', $('#input-type-tab input[type="radio"]:checked').val() )

	# Finish up editing by changing the current activity
	'click #close-tab-menu': (e)->
		Session.set('createForm-activity', '')

)
