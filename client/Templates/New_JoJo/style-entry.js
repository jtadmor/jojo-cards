
// ----------------- ENTRY STYLE MODAL -----------------

Template.style_entry.helpers({});

Template.style_entry.events({

	// Save the data from the model entries and close the form
	'click #submit-styles': function(e) {

		// Create the entryData object
		entryDisplayData = {};
		
		// Run through each entry container 
		$('.entry-container').each(function(){

			// Grab the entryName associated with this entry
			entryName = Blaze.getData(this).name;
			entryDisplayData[entryName] = {};
			// Set the "pre" display data
			console.log('pre data', $(this).find('.entry-name').data())
			entryDisplayData[entryName].pre = $(this).find('.entry-name').data();
			// Set the "field" display data
			console.log('field data', $(this).find('.entry-data').data())
			entryDisplayData[entryName].field = $(this).find('.entry-data').data();
		});

		// Save to JoJoDB
		JoJoDB.update(Session.get('currentJoJo'), {$set: {'entries.displayData': entryDisplayData}});
	
		// Clear out the modal and close it
		$('#form-edit-modal').empty().foundation('reveal','close');
	}

});

// ---------------- MODEL ENTRY --------------------

// Add event handlers to allow user to make each part bold or italic, and edit the text of the pre by clicking on it

