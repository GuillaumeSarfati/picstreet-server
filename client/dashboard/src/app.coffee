#------------------------------------------------
# __API_URL__ = "http://172.20.10.4:3000"
# __API_URL__ = "http://192.168.2.1:3000"
# __API_URL__ = "http://192.168.73.111:3000"
# __API_URL__ = "http://bottlebooking-dev778.eu-west-1.elasticbeanstalk.com"
__API_URL__ = "http://picstreet-staging.eu-west-1.elasticbeanstalk.com"
__API_URL__ = "http://localhost:3000" if window.location.href.match 'localhost'

console.log "%c[Pixer API] : #{__API_URL__}" , 'color: green;'

#------------------------------------------------
__rights =
	everyone: 0
	guest: 1
	member: 2
	admin: 3

__uptime = moment()

angular.module 'picstreet', [

	'ngResource'
	'ngCordova'
	'ngStorage'

	'ionic'
	'ionic-native-transitions'

	'lbServices'
	'ngPicstreet'

	'ngIOS9UIWebViewPatch'

	'picstreet.translate'
	'picstreet.directives'

	'picstreet.authenticated'
	'picstreet.unauthenticated'

]
.config ($ionicNativeTransitionsProvider, $ionicConfigProvider, $urlRouterProvider, LoopBackResourceProvider, $httpProvider) ->

	$ionicConfigProvider.views.swipeBackEnabled(false)

	$ionicNativeTransitionsProvider.setDefaultOptions
		duration: 400, # in milliseconds (ms), default 400,
		slowdownfactor: 4, # overlap views (higher number is more) or no overlap (1), default 4
		iosdelay: -1, # ms to wait for the iOS webview to update before animation kicks in, default -1
		androiddelay: -1, # same as above but for Android, default -1
		winphonedelay: -1, # same as above but for Windows Phone, default -1,
		fixedPixelsTop: 0, # the number of pixels of your fixed header, default 0 (iOS and Android)
		fixedPixelsBottom: 0, # the number of pixels of your fixed footer (f.i. a tab bar), default 0 (iOS and Android)
		triggerTransitionEvent: '$ionicView.afterEnter', # internal ionic-native-transitions option
		backInOppositeDirection: false # Takes over default back transition and state back transition to use the opposite direction transition to go back
	 
	$ionicNativeTransitionsProvider.setDefaultTransition
		type: 'slide'
		direction: 'left'

	$ionicNativeTransitionsProvider.setDefaultBackTransition
		type: 'slide',
		direction: 'right'

	$urlRouterProvider.otherwise '/login'

	LoopBackResourceProvider.setAuthHeader 'X-Access-Token'
	LoopBackResourceProvider.setUrlBase "#{__API_URL__}/api"

	# $httpProvider.interceptors.push 'loader'
	$httpProvider.defaults.useXDomain = true
	
	delete $httpProvider.defaults.headers.common['X-Requested-With']

.run ($connect, $ionicHistory, $ionicNativeTransitions, $rootScope, $state, $ionicPlatform, $cordovaStatusbar, $cordovaDialogs, $filter) ->

	$connect.remember (me) -> 
		console.log 'REMEMBER ME', me

		if me
			if $state.current.name is 'login'
				$state.go 'authenticated.map'

		else
			$state.go 'login'

	$ionicPlatform.ready ->
		document.addEventListener "pause", ->
			console.log 'pause'
		document.addEventListener "resume", ->
			console.log 'resume'
			__uptime = moment()


	$ionicPlatform.ready ->

		# $notification.request()
		# $notification.register()
		
		if window.cordova
			$cordovaStatusbar.styleColor('white')
			if window.cordova.plugins.Keyboard
				cordova.plugins.Keyboard.disableScroll true

# .run ($ionicPopover, $rootScope, $notification, $ionicNativeTransitions, $state) ->

# 	$notification

# 	#---------------------------------------------------
# 	# Chat Notification Configuration
# 	#---------------------------------------------------
# 	.type 'chat',

# 		state:
# 			#this param determine if notify or update
# 			name: 'authenticated.room'

# 			#link $stateParams.id to notification.additionalData.roomId
# 			paramsLink: id: 'roomId'
		
# 		# when the app is close or in background
# 		deep: (notification) ->
# 			console.log '----------------------'
# 			console.log 'deep : ', notification
# 			console.log '----------------------'
			
# 			if $rootScope.me
# 				# $state.go 'authenticated.room'
# 				# , { id: notification.additionalData.roomId }
# 				$ionicNativeTransitions.stateGo 'authenticated.room'
# 				, { id: notification.additionalData.roomId }
# 				, { type: "flip", direction: "left", duration: 400 }
# 				, { reload: true }
			
# 			else
			
# 				$rootScope.$on 'request:connect', ->
# 					$rootScope.isOpenedByNotification = true
# 					# $state.go 'authenticated.room'
# 					# , { id: notification.additionalData.roomId }
# 					$ionicNativeTransitions.stateGo 'authenticated.room'
# 					, { id: notification.additionalData.roomId }
# 					, { type: "flip", direction: "left", duration: 400 }
# 					, { reload: true }


# 		# when the app isn't in the good state
# 		notify: (notification) ->
# 			console.log '----------------------'
# 			console.log 'notify : ', notification
# 			console.log '----------------------'
			
# 			$notification.show notification,
# 				templateUrl: 'notification.chat.html'
# 				backdrop: false
				
# 				timeout: (notification, elem) =>
# 					elem.release()

# 				click: (notification, elem) =>
# 					elem.release()
# 					# You can redirect to @deep(notification) if is the same behavior
# 					$ionicNativeTransitions.stateGo 'authenticated.room'
# 					, { id: notification.additionalData.roomId }
# 					, { type: "slide", direction: "down", duration: 400 }
# 					, { reload: true }

# 		# when the app is in the good state
# 		update: (notification) ->
# 			console.log '----------------------'
# 			console.log 'update : ', notification
# 			console.log '----------------------'
# 			$rootScope.$broadcast "room:#{notification.additionalData.roomId}", notification

# 	#---------------------------------------------------
# 	# Event Notification Configuration
# 	#---------------------------------------------------

# 	.type 'event',
# 		state:
# 			name: 'authenticated.event'
# 			paramsLink: id: 'eventId'
		
# 		deep: (notification) ->

# 			$ionicNativeTransitions.stateGo 'authenticated.event'
# 			, { id: notification.additionalData.eventId }
# 			, { type: "flip", direction: "left", duration: 400 }
# 			, { reload: true }

# 		notify: (notification) ->
			
# 			$notification.show notification,
# 				templateUrl: 'notification.event.html'

# 				timeout: (notification, elem) =>
# 					elem.release()

# 				click: (notification, elem) =>
# 					elem.release()

# 					$ionicNativeTransitions.stateGo 'authenticated.event'
# 					, { id: notification.additionalData.eventId }
# 					, { type: "slide", direction: "down", duration: 400 }
# 					, { reload: true }

# 	.type 'general',
# 		# state:
# 			# name: 'authenticated.event'
# 			# paramsLink: id: 'eventId'
		
# 		deep: (notification) ->

# 			@notify notification
# 			# $ionicNativeTransitions.stateGo 'authenticated.event'
# 			# , { id: notification.additionalData.eventId }
# 			# , { type: "flip", direction: "left", duration: 400 }
# 			# , { reload: true }

# 		notify: (notification) ->
			
			
# 			popoverScope = undefined
# 			popoverScope = $rootScope.$new()
# 			popoverScope.notification = notification.additionalData.data.notification
# 			popoverScope.api = __API_URL__
# 			$ionicPopover.fromTemplateUrl 'notification.view.html',
# 				scope: popoverScope

# 			.then (popover) ->
# 				console.log 'POPOVER : ', popover
				
# 				popover.scope.popover = popover

# 				# popover.scope.notification =
# 				# 	value: 0
# 				# 	comment: ''
# 				popover.scope.popover.show()

# 				popover.scope.view = (notification) ->
					
# 					ionic.requestAnimationFrame ->
# 						console.log popover.el
# 						popover.el.style.transition = 'all .3s ease'
# 						popover.el.style.backgroundColor = 'rgba(0, 0, 0, 0)'
# 						popover.el.querySelector '#notification'
# 						.classList.add 'leave'
						
# 						setTimeout ->
# 							popover.scope.popover.hide()
# 						, 800

# 			# $notification.show notification,
# 			# 	templateUrl: 'notification.event.html'

# 			# 	timeout: (notification, elem) =>
# 			# 		elem.release()

# 			# 	click: (notification, elem) =>
# 			# 		elem.release()

# 			# 		$ionicNativeTransitions.stateGo 'authenticated.event'
# 			# 		, { id: notification.additionalData.eventId }
# 			# 		, { type: "slide", direction: "down", duration: 400 }
# 			# 		, { reload: true }

# 	console.log '------------------------------'
# 	console.log 'NOTIFICATION WATCH'
# 	console.log '------------------------------'
	
# 	$notification.watch()


