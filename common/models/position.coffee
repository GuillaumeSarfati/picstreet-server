module.exports = (Position) ->

	Position.afterRemote 'create', (ctx, instance, next) ->
		
		if instance.customerId
			Position.app.io.sockets.emit 'customer:position:update', instance

		if instance.photographerId
			Position.app.io.sockets.emit 'photographer:position:update', instance

		next()
