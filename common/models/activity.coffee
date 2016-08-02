module.exports = (Activity) ->

	Activity.afterRemote 'create', (ctx, instance, next) ->

		console.log 'CREATE ACTIVITY'
		
		if instance.customerId
			Activity.app.io.sockets.emit 'acticity:customer', instance
			Activity.app.io.sockets.emit "activity:customer:#{instance.customerId}", instance

		if instance.photographerId
			Activity.app.io.sockets.emit "activity:photographer", instance
			Activity.app.io.sockets.emit "activity:photographer:#{instance.photographerId}", instance
