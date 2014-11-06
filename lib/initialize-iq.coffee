# Create a new Inspirational Quotes

createIQ = () ->
	IQ = new JoJo {name: 'Inspirational Quotes', rateIt: true, sortBy: 'rating'}

	# Add the input information here
	authorInput = new Input {prompt: 'Author'}
	quoteInput = new Input {prompt: 'Quotation'}
	quoteSource = new Input {prompt: 'Source'}

	IQ.inputs.push(authorInput); 
	IQ.inputs.push(quoteInput);
	IQ.inputs.push(quoteSource);

	# Return the JoJo
	IQ