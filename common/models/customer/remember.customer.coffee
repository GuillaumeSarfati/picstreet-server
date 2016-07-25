module.exports = (Customer) ->

					
	Customer.remember = (req, filter, callback) ->

		AccessToken = Customer.app.models.AccessToken

		


		AccessToken.findForRequest req, (err, accessToken) ->
			console.log err, accessToken
			
			unless accessToken
				error = new Error
				error.status = 401
				callback error

			else
				
				filter.where = {} unless filter.where
				filter.where.id = accessToken.userId unless filter.where.id

				Customer.findOne filter
				, callback


	Customer.remoteMethod 'remember',
		accepts: [
			{arg: 'req', type: 'object', http: source: 'req'}
			{arg: 'filter', type: 'object', required: true},
		],
		returns: {arg: 'customer', type: 'object', root: true},
		http: {path: '/remember', verb: 'get'}
			
	