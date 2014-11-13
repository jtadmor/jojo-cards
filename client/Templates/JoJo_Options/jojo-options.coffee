# ----------- JoJo Options ------------------

Template.jojo_options.rendered = () ->
	$('.jojo-options-container').foundation()


Template.jojo_options.helpers(

	'publicJoJo': () ->
		ispublic = if JoJoDB.findOne(@).public then true else false
		ispublic
)

Template.jojo_options.events(

	# Create new public jojos with out entries
	'click #make-public-form-only': () ->
		console.log JoJoDB.findOne(@, {fields: {_id: 0}})
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
				console.log 'Entries', JoJoDB.findOne(jojoId, {fields: {'entries.entryIDs': 1, _id: 0}}).entries.entryIDs
				EntriesDB.find({_id: {$in: JoJoDB.findOne(jojoId, {fields: {'entries.entryIDs': 1}}).entries.entryIDs }}).forEach( 
					(entry) ->
						EntriesDB.insert(_.omit(entry, '_id'), (error, entryId) ->
							if err
								console.log err
							else
								console.log('entry', entry)
								console.log('original entry id', entry._id)
								# Update the JoJo to include a reference to new entry, update entry to point to public jojo
								JoJoDB.update(jojoId, {$push: {'entries.entryIDs': entryId}, $set: {public: true}})
								JoJoDB.update(jojoId, {$pull: {'entries.entryIDs': entry._id}})
								EntriesDB.update(entryId, {$set: {jojoId: jojoId}})
							null
						)
						# Return line for the forEach
						null
					)

			# Return line for the insert	
			null
		)
)