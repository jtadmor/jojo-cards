# ----------- JoJo Options ------------------

Template.jojo_options.rendered = () ->
	$('.jojo-options-container').foundation()


Template.jojo_options.helpers(

	'publicJoJo': () ->
		ispublic = if JoJoDB.findOne(@).public then true else false
		ispublic

	'nameFixed': () ->
		@.name.replace(/[\s-.@#$%^&*.,<>]/g, '_')

	'myjojos': ()->
		#  Return all the user's jojos except the currently active one
		JoJoDB.find({userId: Meteor.userId(), _id: {$ne: Session.get('currentJoJo')}})
)

Template.jojo_options.events(

	# Create new public jojos with out entries
	'click #make-public-form-only': () ->
		# Find the current jojo, and insert a copy of it into the database, without its _id, then update to make public remove the entries
		JoJoDB.insert(JoJoDB.findOne(@, {fields: {_id: 0}}),
			(err, id) ->
				if err 
					console.log err
				else 
					JoJoDB.update(id, {$set: {public: true, 'entries.entryIDs':{} }})
				null
		)

	# Create new public jojo and make all entries public
	'click #make-public-copy-entries': () ->
		# Find the current jojo, and insert a copy of it into the database without its _id, then insert all of the entries into the public db, and update the entry array with each of those entries
		JoJoDB.insert(JoJoDB.findOne(@, {fields: {_id: 0}}), (err, jojoId) ->
			if err 
				console.log err
			else 
				# Grab all the entries (without _id), and for each insert a new copy into EntriesDB
				EntriesDB.find({_id: {$in: JoJoDB.findOne(jojoId, {fields: {'entries.entryIDs': 1}}).entries.entryIDs }}).forEach( 
					(entry) ->
						EntriesDB.insert({jojoId: jojoId, data: entry.data}, (error, entryId) ->
							if err
								console.log err
							else
								# Update the JoJo to include a reference to new entry, update entry to point to public jojo
								JoJoDB.update(jojoId, {$push: {'entries.entryIDs': entryId}, $set: {public: true}})
								JoJoDB.update(jojoId, {$pull: {'entries.entryIDs': entry._id}})
								# EntriesDB.update(entryId, {$set: {jojoId: jojoId}})
							null
						)
						# Return line for the forEach
						null
					)

			# Return line for the insert	
			null
		)

		# # Learn a new trick by field
		# 'click #pin-by-field': () ->
		# 	# Get needed values and set up a blank query
		# 	field = $('#field-to-combine').val()
		# 	targetjojoid = $('#jojo-to-combine').val()
		# 	query = {}

		# 	# Go through each entry in the current jojo
		# 	pinTo = EntriesDB.find({_id: {$in: JoJoDB.findOne(Session.get('currentJoJo')).entries.entryIDs}).map((entry)->
		# 		# Find this entry's match in the other jojo, only publish the ID for any that are found
		# 		query[field] = entry[field]
		# 		EntriesDB.find({$and: [{jojoId: targetjojoid}, query]}, {fields: {_id: 1}}).fetch()
		# 	)

		# 	console.log(pinTo)
		# 	null
)