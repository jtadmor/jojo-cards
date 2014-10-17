-------------------------------------------
			IMPLEMENTATION 
-------------------------------------------

Data Structure
----------------

************

Collections:

************

JoJoDB: An array of all (public and private) JoJos. Each contrains:
	* The jojo
	* userId of creator
	* public (boolean)
	* array of userId for any users that can view (public automatically allows any user to view it in the public folder, but creators of private jojos can share them with other users) 


*************

Prototypes:

*************

----------------
JoJo: has meta-info about entries and contains the entries in an array.

Data:
	* The name (as inputted by user) of the JoJo
	* Array of the inputs as Input objects
	* Array of entries as Entry objects
	* Meteor / Blaze template for displaying entries 
	* Further variables (groupBy, sortBy, titleBy, rateIt) used to search, group, and sort entries

Methods:
	* displayEntries: based on the passed arguments, creates an array of entries and calls Blaze.renderWithData on the jojo's template with that 
	
---------------
Entry: contains information about individual entries

Data:
	* The name of the parent jojo (as represented in the Mongo collection)
	* A unique ID for the entry
	* The form data captured when the entry was created
	* (Possible) other variables for displaying, grouping, sorting, and combining the entry.

Methods:


-----------------
Input: stores the form inputs

Data:
	* The name of the input (equal to the prompt unless the user overrides by adding a name)
	* The prompt 
	* The type of input
	* An array of how many inputs / options (will be 1 unless radio, checkbox, or select)
	* Attributes (default values, required, etc.)
