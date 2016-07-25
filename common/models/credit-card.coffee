
module.exports = (CreditCard) ->
	

	CreditCard.beforeRemote 'create', (ctx, instance, cb) ->
		stripe = require('stripe')(CreditCard.app.settings.stripe.secretKey)
		stripe.customers.createSource ctx.req.body.customerStripeId
		, source: ctx.req.body.stripeInitialToken
		, (err, card) ->
			
			if err

				error = new Error()
				error.message = err.message
				error.status = err.statusCode

				cb error
				
			else

				ctx.req.body.stripeId = card.id 
				ctx.req.body.brand = card.brand 
				cb()

	CreditCard.beforeRemote 'deleteById', (ctx, instance, cb) ->
		CreditCard.findOne
			where:
				id: ctx.args.id
			include: 'customer'
		, (err, card) ->
			stripe = require('stripe')(CreditCard.app.settings.stripe.secretKey)
			stripe.customers.deleteCard card.customer().stripeId, card.stripeId 
			, cb





