module.exports = (Photographer) ->

					
	Photographer.remember = (req, filter, callback) ->

		AccessToken = Photographer.app.models.AccessToken

		AccessToken.findForRequest req, (err, accessToken) ->
			
			unless accessToken
				
				error = new Error
				error.status = 401
				callback error

			else
				
				filter.where = {} unless filter.where
				filter.where.id = accessToken.userId unless filter.where.id

				Photographer.findOne filter
				, callback


	Photographer.remoteMethod 'remember',
		accepts: [
			{arg: 'req', type: 'object', http: source: 'req'}
			{arg: 'filter', type: 'object', required: true},
		],
		returns: {arg: 'customer', type: 'object', root: true},
		http: {path: '/remember', verb: 'get'}
			
	