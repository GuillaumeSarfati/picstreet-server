angular.module 'picstreet'

.service '$connect', (LoopBackAuth, Photographer, $rootScope) ->
		
	$connect = 

		signup: (me, opts={}, callback) ->

			Photographer.create me
			.$promise
			.then callback
			.catch (err) -> console.log 'err : ', err

		login: (opts={}, callback=->) ->

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
				

			.catch (err) -> callback false


		logout: (callback)->

			Photographer.logout()
			callback()

		remember: (callback=->) ->
			
			if window.localStorage.getItem '$LoopBack$accessTokenId'
				
				console.log '$connect:localStorage'
				
				Photographer.getCurrent 
					filter:
						include: 'albums'
				.$promise
				.then (me) ->
					$rootScope.me = me
					console.log 'ME : ', me
					callback me
				.catch (err) -> callback false
			else
				callback false
				

