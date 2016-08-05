angular.module 'picstreet'

.service '$connect', (LoopBackAuth, Photographer, Activity, $rootScope, $socket) ->
		
	$connect = 

		signup: (me, opts={}, callback) ->

			console.log 'signup : ', me
			Photographer.create me
			.$promise
			.then callback
			.catch (err) -> console.log 'err signup: ', err

		login: (opts={}, callback=->) ->
			console.log 'login : ', opts
			Photographer.login

				email: opts.email
				password: opts.password
				rememberMe: true

			.$promise
			.then (accessToken) ->
			
				LoopBackAuth.setUser(accessToken.id, accessToken.userId, accessToken.user)
				LoopBackAuth.rememberMe = true
				LoopBackAuth.save()

				callback accessToken
				

			.catch (err) -> 
				console.log 'err login : ', err
				callback false

		logout: (callback)->

			Photographer.logout()
			callback() if callback
			$rootScope.me = undefined
			$rootScope.$emit '$unauthenticated'
			window.location = '#/login'

		remember: (callback=->) ->
			
			console.log 'remember'
			if $rootScope.me
				callback $rootScope.me

			else if window.localStorage.getItem '$LoopBack$accessTokenId'
				
				Photographer.getCurrent 
					filter:
						include: [
							'roles'
							'photographers'
							'albums'
							'picturePurchases'
						]
				.$promise
				.then (me) ->
					Activity.create
						type: 'dashboard:connect'
						photographerId: me.id
					
					$rootScope.me = me
					$rootScope.$emit '$authenticated', me

					callback $rootScope.me
				.catch (err) ->
					console.log 'err remember : ', err
					callback false
			else
				callback false
				

