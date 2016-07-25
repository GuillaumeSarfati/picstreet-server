angular.module 'picstreet'

.service '$pxModal', ($rootScope, $ionicModal, $controller) ->
	
	$bbModal = 

		getPaymentMethods: (bindScope={}, callback=->) ->

			$bbModal.getModal 

				name: 'PaymentMethods'
				templateUrl: 'payment.view.html'
				controller: 'paymentCtrl'
				bindScope: bindScope

			, (modal, modalScope) ->
				
				modalScope.isModal = true
				
				modalScope.selectCreditCard = (card) ->
					$rootScope.$broadcast '$card:update', card
					modalScope.modal.hide()

				callback modal, modalScope

		getMyPictures: (bindScope={}, callback=->) ->

			$bbModal.getModal 

				name: 'MyPictures'
				templateUrl: 'pictures.view.html'
				controller: 'picturesCtrl'
				bindScope: bindScope

			, (modal, modalScope) ->
				
				modalScope.isModal = true
				
				modalScope.selectCreditCard = (card) ->
					$rootScope.$broadcast '$card:update', card
					modalScope.modal.hide()

				callback modal, modalScope

	

		getModal: (opts, callback=->) ->

			if opts.templateUrl is undefined
				return callback new Error "opts.templateUrl is undefined"

			modalScope = $rootScope.$new()

			if Object.keys(opts.bindScope).length
				for propertyName, propertyValue of opts.bindScope
					modalScope[propertyName] = propertyValue

			if opts.controller
				$controller opts.controller, 
					$scope: modalScope

			$ionicModal.fromTemplateUrl opts.templateUrl,
				scope: modalScope
				animation: opts.animation||'slide-in-up'
			.then (modal) ->

				modalScope.modal = modal

				modalScope.show = ->
					modal.show()
					console.log  "$bb:modal:#{opts.name||'x'}:show"

				modalScope.hide = (state=undefined) ->
					modal.hide()
					console.log  "$bb:modal:#{opts.name||'x'}:hide"

				callback modal, modalScope