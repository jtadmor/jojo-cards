-------------------------------------------
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/jtadmor/jojo?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
			FILE ORGANIZATION 
-------------------------------------------

Templates
---------

Templates and their associated helpers / event handlers are in client/Templates/__

Subfolders include: 

* Layout: Layout (controls display of jojo menu or login menu) and the jojo menu
* Home: The welcome page, displayed upon loging in
* Entries: Displaying a jojo's entries and creating new entries
* New JoJo: Creating a new jojo, including the modals for creating forms and styling entries
* Profile: Displaying a user's profile

global-helpers.coffee contains the helpers that are accessible to all templates.


-------------------------------------------
			IMPLEMENTATION NOTES
-------------------------------------------


Session Variables
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

JoJoDB: Collection of all (public and private) JoJos. Each contains:
	* JoJo options
	* Name
	* Entries information (including the entryIDs)
	* Form information (the form legend and the Inputs array)
	* userId of the creator
	* public (boolean)

