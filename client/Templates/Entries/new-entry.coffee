# EVENTS AND HANDLERS FOR CREATING A NEW ENTRY WITHIN THE CURRENT JOJO

# ------------- NEW ENTRY FORM ---------------

Template.new_entry.helpers(
	# Create 11 inputContainers
	inputContainers: () ->
		[0..11]

	# Find the nth child div that matches the position of the current input, and render the input there
	inputDisplay: () ->
		console.log Template.currentData()
		# Blaze.renderWithData(Template.input, Template.currentData())
)


# -------------- INPUTS ---------------------	

Template.input.helpers(
	
	

)