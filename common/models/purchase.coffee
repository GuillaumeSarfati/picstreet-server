async = require 'async'

module.exports = (Purchase) ->

	Purchase.afterRemote 'create', (ctx, instance, next) ->

		Customer = Purchase.app.models.Customer
		
		CreditCard = Purchase.app.models.CreditCard
		Charge = Purchase.app.models.Charge

		Picture = Purchase.app.models.Picture
		PicturePurchase = Purchase.app.models.PicturePurchase
		
		PromotionCode = Purchase.app.models.PromotionCode
		UsedPromotionCode = Purchase.app.models.UsedPromotionCode

		async.waterfall [
			(done) ->
				
				Picture.find 
					where:
						id:
							inq: instance.pictures.map (picture) -> picture.id
				, done
			
			(pictures, done) ->

				Customer.findOne
					where: id: instance.customerId
				, (err, customer) ->
					done err, pictures, customer

			(pictures, customer, done) ->
				
				if instance.promotionCodeId


					PromotionCode.findOne where: id: instance.promotionCodeId
					, (err, promotionCode) ->
						UsedPromotionCode.findOne
							where:
								promotionCodeId: promotionCode.id
								customerId: customer.id
						, (err, usedPromotionCode) ->

							if usedPromotionCode
								instance.promotionCodeId = undefined
								done err, pictures, customer, undefined

							else
								instance.promotionCode = promotionCode
								done err, pictures, customer, promotionCode
						
				else
					done null, pictures, customer, undefined

			(pictures, customer, promotionCode, done) ->
				price = 0

				for picture in pictures 
					price += picture.price

				if promotionCode
					price -= promotionCode.amount

				done null, customer, price * 100
				
			(customer, price, done) ->
				
				CreditCard.findOne
					where:
						customerId: customer.id
						id: instance.creditCardId
				, (err, creditCard) ->
					done err, customer, price, creditCard



			(customer, price, creditCard, done) ->

				stripe = require('stripe')(Purchase.app.settings.stripe.secretKey)
				stripe.charges.create
					description: 'PicStreet purchase ' + instance.id
					amount: price
					currency: 'eur'
					customer: customer.stripeId
					card: creditCard.stripeId
					capture: false
				, (err, charge) ->
					console.log 'create charge'
					console.log err, charge
					done err, charge

			(charge, done) ->
				charge.purchaseId = instance.id

				Charge.create charge
				, done

			(charge, done) ->
				console.log 'charge status : ', charge.status
				if charge.status is 'succeeded'
					if instance.promotionCodeId

						UsedPromotionCode.create
							promotionCodeId: instance.promotionCodeId
							customerId: instance.customerId
						, done

					else
						done null, undefined

			(usedPromotionCode, done) ->
				picturesPurchases = instance.pictures.map (picture) ->
					photographerId: picture.photographerId
					customerId: instance.customerId
					purchaseId: instance.id
					pictureId: picture.id
					price: picture.price
				PicturePurchase.create picturesPurchases
				, (err, picturesPurchases) ->
					done err, picturesPurchases

		], (err, results) ->
			console.log 'end'
			return next err if err
			return instance.save next
			