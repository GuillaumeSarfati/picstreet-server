# handleOpenURL = undefined

# angular.module 'picstreet'

# .run ($state, $ionicModal, $rootScope, Event, $bbModal, $ionicNativeTransitions)->

# 	console.log '$urlSchemes'

# 	urlSchemes = [
# 		{name: 'EAC1', pattern: ///bb://([A-Z0-9]{5}$) /// , fn: 'enterActivationCode'}
# 		{name: 'OP1', pattern: ///bb://event/([\w]+$) /// , fn: 'openEvent'}
# 	]

# 	# START FN WHEN URL MATCH TO URLSCHEME PATTERN
# 	handleOpenURL = (url) ->
# 		setTimeout ->
# 			for urlScheme in urlSchemes
# 				if match = urlScheme.pattern.exec url 
# 					handleOpenURL[urlScheme.fn](match, url, urlScheme)
# 		, 0

# 	# ENTER ACTIVATION CODE URL EXAMPLE bb://AZX83
# 	handleOpenURL.enterActivationCode = (match) ->

# 		$bbModal.getActivateMyAccount {}, (modal, modalScope) ->
# 			$rootScope.$broadcast 'accessCode:load:from:sms', match[1], modal
# 			modalScope.show()


# 	# OPEN EVENT URL EXAMPLE bb://event/5699182321b0688a38ae8200
# 	handleOpenURL.openEvent = (match) ->
		
# 		Event.findOne
# 			filter: 
# 				where: 
# 					id: match[1]
# 				include: ['club', 'configuration']
# 		.$promise
# 		.then (event) ->
# 			$ionicNativeTransitions.stateGo 'authenticated.event',
# 				id: match[1]
# 				event: event
# 			, 
# 				type: "slide"
# 				direction: "left"
# 				duration: 400

			
# 		.catch (err) -> console.log 'handleOpenURL:openEvent:error', err

