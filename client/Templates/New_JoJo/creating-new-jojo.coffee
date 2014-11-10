###

Template helpers and event handlers for creating a new jojo.

###

Template.creating_new_jojo.helpers(
	# Display text of step
	newJoJoStep: () ->
		Session.get('newJoJoStep')

	# Helpers for which step it is
	step2: () ->
		Session.get('newJoJoStep').match(/Two/)

	step3: () ->
		Session.get('newJoJoStep').match(/Three/)

	step4: () ->
		Session.get('newJoJoStep').match(/Four/)
)


Template.creating_new_jojo.events(

	# Events for moving to next step
	# Move the step up if on the prior step

	# Hit enter when submitting name to move on and insert a new jojo into the DB
	'keypress #set-jojo-title': (e) ->
		if Session.get('newJoJoStep').match(/One/)
			if e.which is 13
				e.preventDefault()
				Session.set('newJoJoStep', 'Step Two: Create The Form')
				
				# Create a new JoJoDB entry with some defaults
				# Set the new currentJoJo by grabbing the id
				JoJoDB.insert({userId: Meteor.userId(), public: false, name: $(e.target).val(), form: {inputs: []}, entries: {entryIDs: []}, options: {}}, (err, id) ->
					if err then console.log err
					else
						console.log(id)
						Session.set('currentJoJo', id)
				)
		# No key press once the name is submitted
		else
			e.preventDefault()


	# Move up a step and open the create form modal
	'click #create-form': (e) ->
		if Session.get('newJoJoStep').match(/Two/) 
			# Update Sessions
			Session.set('newJoJoStep', 'Step Three: Style The Entries')
			Session.set('createForm-activity', '')

			# Render the template and open the modal
			Blaze.render(Template.create_form, $('#form-edit-modal')[0])
			$('#form-edit-modal').foundation('reveal','open')

	'click #style-entry': (e) ->
		if Session.get('newJoJoStep').match(/Three/)
			# Update session
			Session.set('newJoJoStep', 'Step Four: Advanced Settings (optional)')

			# Render the template with the data from the current jojo and open the modal
			Blaze.renderWithData(Template.style_entry, JoJoDB.findOne(Session.get('currentJoJo')), $('#form-edit-modal')[0])
			$('#form-edit-modal').foundation('reveal','open')

	'click #customize-jojo': (e) ->
		# Open custom buttons

	'click #finalize-creation': (e) ->
		# Reset current activity
		Session.set('currentActivity', '')

		# Empty the modal (shouldn't be needed now that the modals empty on close)
		# $('.form-sandbox').empty()
)