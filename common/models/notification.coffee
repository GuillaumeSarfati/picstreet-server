module.exports = (Notification) ->

	Notification.afterRemote 'create', (ctx, instance, next) ->
		Notification.send ctx.result
		, next
		
	Notification.send = (notification, callback) ->
		Sns = Notification.app.models.Sns
		Sns.publish
			MessageStructure: 'json'
						
			Message: JSON.stringify

				default: notification.message

				APNS: JSON.stringify
					aps: alert: notification.message
					type: notification.type
					data:
						notification: notification
				APNS_SANDBOX: JSON.stringify
					aps: alert: notification.message
					type: notification.type
					data:
						notification: notification
			TargetArn: 'arn:aws:sns:eu-west-1:582765234147:general'
		, callback



	Notification.remoteMethod 'send', 
		description: 'Send notification to General Topic Subscriber'
		accepts: [
			{
				arg: 'notification'
				type: 'object'
				http: source: 'body'
			}
		]
		returns:
			root: true
			arg: 'result'
			type: 'object'
		http:
			verb: 'post'
			path: '/send'