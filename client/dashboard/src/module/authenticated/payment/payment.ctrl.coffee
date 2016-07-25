angular.module "picstreet.payment"

.controller "paymentCtrl", ($rootScope, $scope, $cordovaDialogs, CreditCard, $filter) ->

	Stripe.setPublishableKey 'pk_live_uar4MHdwhBw7IJ30tnogt3xu'
	
	# $scope.cards = $rootScope.me.creditCards

	$scope.deleteCard = (card) ->
		
		$cordovaDialogs.confirm $filter('translate')('deleteCreditCard'), 'Bottle Booking', ['Ok', 'Cancel']
		.then (index) ->

			button = if window.cordova then 2 else 1
			
			if index is button
				
				Action.create
					name: 'delete:card'
					
				$scope.cards.splice $scope.cards.indexOf(card), 1
				
				CreditCard.deleteById id: card.id
				.$promise
				.then (success) -> console.log 'success : ', success
				.catch (err) -> console.log 'err : ', err


	scanCard = ->

		CardIO.scan

			collect_expiry: true,
			collect_cvv: false,
			collect_zip: false,
			shows_first_use_alert: true,
			disable_manual_entry_buttons: false

		, scanSuccess
		, scanErr

	scanCardMock = ->
		scanSuccess
			# card_number: '4000000000000341' # Charge fail
			card_number: '4242424242424242'
			cvv: '874'
			expiry_month: 4
			expiry_year: 2019
			
	scanErr = (err) ->

		$scope.$emit 'loading:hide', force: true

	scanSuccess = (scan) ->
		alert 'card'
		$scope.$emit 'loading:unlock', force: true
		$scope.$emit 'loading:show', force: true
		
		

		Stripe.card.createToken
			number: scan.card_number
			cvc: scan.cvv
			exp_month: scan.expiry_month
			exp_year: scan.expiry_year

		, createCard

	createCard =  (status, response) ->
		
		console.log 'STRIPE STATUS : ', status
		console.log 'STRIPE RESPONSE : ', response

		$scope.$emit 'loading:hide', force: true
		$scope.$emit 'loading:lock', force: true

		CreditCard.create
			stripeInitialToken: response.id
			last4: response.card.last4
			type: response.card.type
			expMonth: response.card.exp_month
			expYear: response.card.exp_year
			country: response.card.country

		.$promise
		.then (card) -> 

			
			if card.error
				$cordovaDialogs.alert card.error.message, 'Bottle Booking', 'Ok' 
			
			else
				console.log '---------------------------------'
				console.log '- CREATE CREDIT CARD'
				console.log '---------------------------------'
				console.log 'card : ', card
				console.log 'creditCards : ', $rootScope.me.creditCards
				console.log 'creditCards.length : ', $rootScope.me.creditCards.length
				console.log 'defaultcreditCards : ', $rootScope.me.defaultCreditCard
				console.log '---------------------------------'
				
				$rootScope.me.creditCards.push card
				$scope.makeDefaultCard card unless $rootScope.me.defaultCreditCard

				
 
				$rootScope.$apply()

		.catch (err) ->

			console.log 'err : ', err

	$scope.makeDefaultCard = (card) ->
		$rootScope.me.defaultCreditCard = card
		$rootScope.me.defaultCreditCardId = card.id


		Customer.prototype$updateAttributes
			id: $rootScope.me.id
		,	defaultCreditCardId: card.id
		.$promise
		.then (err, success) ->
			console.log 'default credit card success : ', err, success
		
		.catch (err) -> 
			console.log 'err : ', err

	$scope.scanCard = ->

		$scope.$emit 'loading:show', force: true

		scanCard()			if window.cordova
		scanCardMock() 	unless window.cordova


