-------------------------------------------
			FILE ORGANIZATION 
-------------------------------------------

Views / templates




-------------------------------------------
			IMPLEMENTATION NOTES
-------------------------------------------


Session Values
------------------

* currentActivity: A (nice looking) string description of the current activity. Where it makes sense, the string description should be easily convertible to the name of the template that allows for it (e.g. when currentActivity is 'New Entry', the 'new_entry' template is used)

* currentJoJo: The JoJoDB _id for the currently selected jojo (which may be the logged in user's private jojo or a public jojo) 

* newJoJoStep: Which step of the creating new jojo process the user is on (strings 'One' - 'Four')

* createForm-activity: A string descrition of the current activity within creating a form


Data Structure
----------------

************

Collections:

************

JoJoDB: An array of all (public and private) JoJos. Each contains:
	* The jojo object
	* userId of the creator
	* public (boolean)

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
