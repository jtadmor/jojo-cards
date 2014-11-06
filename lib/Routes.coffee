# Configure the default layout
Router.configure(
	layoutTemplate: 'top_bar'
)

# Set up the template look-up convertor to go from e.g. 'New Entry' to 'new_entry'
Router.setTemplateNameConverter((str) -> 
	str.toLowerCase().replace(' ', '_')
)

# ---------- ROUTES ------------ 

# Homepage
Router.route('/')


# New Entries
Router.route('/New_Entry', 

	name: 'New Entry' 
	action: () -> @render('new_entry')
)

# Creating New JoJo
Router.route('/Creating_New_JoJo',

	name: 'Creating New JoJo'
	action: () -> @render('creating_new_jojo')
)
