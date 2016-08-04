module.exports = (Album) ->

	Album.submitToReview = (id, callback) ->

		Album.findOne where: id: id
		, (err, album) ->
			if err 
				return callback err

			if album is null
				err = new Error
				err.status = 404
				return callback err

			album.status = 'review'
			album.save callback

	Album.remoteMethod 'submitToReview', 
		description: 'Submit album to Administrator review'
		accepts: [
			{
				arg: 'id'
				type: 'string'
				http: source: 'path'
			}
		]
		returns:
			root: true
			arg: 'result'
			type: 'object'
		http:
			verb: 'post'
			path: '/submit-to-review/:id'

	Album.submitToCustomer = (id, callback) ->

		Album.findOne where: id: id
		, (err, album) ->
			if err 
				return callback err

			if album is null
				err = new Error
				err.status = 404
				return callback err

			album.status = 'validate'
			album.save callback

	Album.remoteMethod 'submitToCustomer', 
		description: 'Submit album to Customer'
		accepts: [
			{
				arg: 'id'
				type: 'string'
				http: source: 'path'
			}
		]
		returns:
			root: true
			arg: 'result'
			type: 'object'
		http:
			verb: 'post'
			path: '/submit-to-customer/:id'