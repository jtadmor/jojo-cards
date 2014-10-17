-------------------------------------------
			IMPLEMENTATION 
-------------------------------------------

Data Structure
----------------

******

JoJo: has meta-info about entries and contains the entries in an array.

******

Data:
	* The name (as inputted by user) of the Category
	* Array of the inputs as Input objects
	* Array of entries as Entry objects
	* Meteor / Blaze template for displaying entries 
	* Further variables (groupBy, sortBy, titleBy, rateIt) used to search, group, and sort entries

Methods:
	* displayEntries: based on the passed arguments, creates an array of entries and calls Blaze.renderWithData on the jojo's template with that 
	

*******

Entry: contains information about individual entries

*******

Data:
	* The name of the parent jojo (as represented in the Mongo collection)
	* A unique ID for the entry
	* The form data captured when the entry was created
	* (Possible) other variables for displaying, grouping, sorting, and combining the entry.

Methods:




Global Variable Scope 
---------------------

Variables:
	* On login / initialization, all of a user's Categories are made into global variables (with no reference to user)
	* On logout, user's Categories are saved to the user's jStorage key
	* masterCategory: the current category in play, as a string
	* window[masterCategory] will access the current Category as an object






Drag-and-Drop 
----------------

Icons:
	* Each icon contains data attributes that correspond to the type of form they will create when dropped 