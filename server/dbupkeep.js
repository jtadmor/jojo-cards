// Database upkeep / cleanup

Meteor.startup(function() {

	// When an entry is deleted, remove the reference to it from the containing jojo
	// (Eventually, remove all references from all tricks)
	var entryUpkeep = EntriesDB.find({}).observe({

		removed: function(entry) {
			JoJoDB.update(entry.jojoId, { $pull: {'entries.entryIDs': entry._id}});
		}

	});
});

