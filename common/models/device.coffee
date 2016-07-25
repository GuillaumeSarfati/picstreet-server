async = require 'async'

module.exports = (Device) ->

	Device.beforeRemote 'create', (ctx, instance, next) ->
		Device.createDeviceEndpoint ctx, instance, next

	Device.beforeRemote 'upsert', (ctx, instance, next) ->
		Device.createDeviceEndpoint ctx, instance, next
		

	Device.createDeviceEndpoint = (ctx, instance, next) ->

		Sns = Device.app.models.Sns
		Customer = Device.app.models.Customer

		if ctx.req.body.id is undefined
			
			async.waterfall [

				createEndpoint = (done) ->
					console.log '-- createEndpoint --'
					Sns.createEndpoint
						token: ctx.req.body.token
					, done

				saveTargetArn = (endpoint, done) ->
					console.log '-- saveTargetArn --'
					ctx.req.body.targetArn = endpoint.EndpointArn
					done()


				subscribeToCustomerTopic = (done) ->
					console.log '-- subscribeToCustomerTopic --'
					Customer.retrieveTopicArn ctx.req.body.customerId, (err, customerTopicArn) ->
						done err if err

						Sns.subscribe
							Protocol: 'application'
							TopicArn: customerTopicArn 
							Endpoint: ctx.req.body.targetArn
						, (err, response) ->
							done err

				subscribeToGeneralTopic = (done) ->
					console.log '-- subscribeToGeneralTopic --'
					Sns.subscribe
						Protocol: 'application'
						TopicArn: 'arn:aws:sns:eu-west-1:582765234147:general'
						Endpoint: ctx.req.body.targetArn
					, (err, data) ->
						console.log err
						console.log data
						done err, data

			], (err, dataX) ->

				notification = 
					title: "Welcome to PicStreet v1.0.0"
					message: "Dear Members, we are pleased to welcome you to the first version of PicStreet."
					picture: 
						name: "image-post-notif.jpg"
						visible: true
						bucket: "picstreet-notifications"
					type: "general"

				Sns = Device.app.models.Sns
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
					TargetArn: ctx.req.body.targetArn
				, (err, response) ->
					console.log '-- async waterfall callback --'
					next err, dataX

		else
			next()







