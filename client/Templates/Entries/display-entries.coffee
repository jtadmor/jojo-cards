# --------------- DISPLAYING ENTRIES ------------

Template.displaying_entries.helpers(

	# Go into the jojo to grab the data needed to render the entry (including whether to render it at all)
	'displayEntry': () ->

		# Render the entry
		Blaze.renderWithData(Template.entry, @, $('#all-entries-container')[0])
		null

	# Return an array of just the entry data
	'data': () ->
		@.map( (entry) -> entry.data)
)


# --------------- INDIVIDIDUAL ENTRY -------------

Template.entry.helpers(

	# Create the object for each field
	'fieldObj': () ->
		for key, value of @
			# NOTE: PRE WILL CHANGE LATER TO REFLECT ENTRY INFO FROM CURRENT JOJO, AND MORE INFO WILL BE ADDED AS DISPLAY
			{pre: key.replace('_', ' ') + ':'	, value: value, field: key}
)


# ----------- INDIVIDUAL FIELD ----------------------

Template.field.events(

	# On clicking the field value of an entry, search for all entries sharing that value
	'click .entry-display-data': (e) ->
		# Grab the source and value
		source = $(e.currentTarget).attr('data-source')
		value = Template.currentData().value

		# Go to displayentries with the current jojo and the search queries
		Router.go("/viewentries/#{Session.get('currentJoJo')}?field=#{source}&value=#{value}")
)
