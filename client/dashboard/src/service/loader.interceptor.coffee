# angular.module 'picstreet'

# .constant '$ionicLoadingConfig',
# 	animation: 'fade-in'
# 	showBackdrop: false
# 	template: '<ion-spinner></ion-spinner>'
# 	hideOnStateChange: true

# .factory 'loader', ($rootScope) ->

# 	request: (config) ->
# 		unless config.url.match /// /api/Actions ///
# 			$rootScope.$broadcast('loading:show')
# 		return config
# 	response: (response) -> $rootScope.$broadcast('loading:hide'); return response
# 	requestError: (err) -> $rootScope.$broadcast('loading:hide'); return err
# 	responseError: (err) -> $rootScope.$broadcast('loading:hide'); return err
 
# .run ($rootScope, $ionicLoading) ->

# 	$rootScope.$on 'loading:lock', (e, opts={}) ->
# 		$rootScope.loadingIsLocked = true

# 	$rootScope.$on 'loading:unlock', (e, opts={}) ->
# 		$rootScope.loadingIsLocked = false

# 	$rootScope.$on 'loading:show', (e, opts={})->
# 		$rootScope.forceLoading = opts.force if opts.force
# 		$ionicLoading.show() unless $rootScope.loadingIsLocked

# 	$rootScope.$on 'loading:hide', (e, opts={}) ->
		
# 		if $rootScope.forceLoading is opts.force
# 			$rootScope.forceLoading = undefined
# 			$ionicLoading.hide() 
		


# 	