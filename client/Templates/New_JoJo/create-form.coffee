# ------------ CREATE FORM MODAL -------------

Template.create_form.events(
	
)

Template.create_form.helpers(
	# Creating the touchable input Toolbar
	# Each clickable has properties 'action' of 'append' or 'trash', 'input' representing the html object, and 'icon' the fa-icon picture
	touchableInput: () ->
		[ { action: 'append', input: 'input', icon: 'font' }, 
		{	action: 'append', input: 'textarea', icon: 'pencil-square-o'}, 
		{	action: 'append', input: 'input type="radio"', icon: 'dot-circle-o'}, 
		{	action: 'append', input: 'input type="checkbox"', icon: 'check-square-o'},
		{ action: 'append', input: 'select', icon: 'list-alt'},
		{ action: 'trash', input: '', icon: 'trash'} ]

	# Create 12 input containers and pass each their index to use in the id
	inputContainer: () ->
		x=[]
		x.push({ind: i}) for i in [0..11]
		x
)

# ---------- INPUT CONTAINERS -----------

Template.input_container.helpers(
	# Set 'empty-active' or 'full-active' based on whether the container has a child element and what the activity is
	isActive: () ->
		# Get which template instance we are working with
		current = Template.instance().data.ind
		
		# Return 'active' as appropriate
		if Session.get('createForm-activity')?.match(/append/)
			'empty-active' if not $("##{current}-input-container").children().length
		else if Session.equals('createForm-activity', 'trash')
			'full-active' if $("##{current}-input-container").children().length
)

Template.input_container.events(
	# Render the model input in an empty-active input-container 
	'click .empty-active': (e, template) ->
		
		# Get the data from active icon
		input = $('.active-icon').data('input')

		# Create the element using the active icon
		el = '<'+ input + '>'
		
		# Get the id of the parent input container
		ind = $(e.target).attr('id').match(/\d+/g)[0]
		
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
		activity = e.target.dataset.action + ' ' + e.target.dataset.input
		Session.set('createForm-activity', activity.trim())
)

# ------------ MODEL INPUTS -------------------

Template.model_input.helpers (
	# Set 'being-edited' if the activity is 'editing [index]' and the index matches
	beingEdited: () ->
		if Session.get('createForm-activity')?.match(/editing/)
			'being-edited' if Session.get('createForm-activity')?.match(/\d+/g)[0] is Template.instance().data.ind
)			

Template.model_input.events (
	# On click, change the activity to reflect the currently edited input and render the tab menu for editing the input. If something is already being edited, do nothing.
	'click .display-only': (e, template) ->
		unless $('#tab-menu-holder').children().length
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
	index = $('#being-edited').closest('.input-container')?.attr('id')?.match(/\d/g)[0]
	this.autorun( ()->
		# Get the index of the currently being edited input's container

		# Destroy if the Session variable is not equal to editing that one
		if not Session.equals('createForm-activity', "editing #{index}")
			$('#tab-menu-holder').empty()
			# Blaze.remove(temp)
	)

Template.editing_input_tab_menu.events(

	# Grab prompt, name, default value from the respective inputs
	'keypress #set-input-prompt': (e) ->
		if e.which is 13 
			$('#being-edited').attr('data-prompt', $(e.target).val())
			$('#being-edited').find('label').text($(e.target).val())

	'keypress #set-input-name': (e)->
		if e.which is 13 
			$('#being-edited').attr('data-name', $(e.target).val())

	'keypress #set-input-default': (e)->
		if e.which is 13 
			$('#being-edited').attr('data-default', $(e.target).val())

	# Toggle input required
	'change #set-input-required': (e)->
		$('#being-edited').attr('data-required', e.target.checked)

	# Add options to radio, checkbox, select
	'keypress #add-input-choice': (e) ->
		domEl = $('#being-edited')
		if e.which is 13
			# Update the data field
			count = domEl.attr('data-choices-count') or 0
			domEl.attr('data-choices-count', Number(count) + 1)
			domEl.attr('data-choices-' + (Number(count)+1), $(e.target).val())

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

	# Finish up editing by changing the current activity
	'click #close-tab-menu': (e)->
		Session.set('createForm-activity', '')

)
