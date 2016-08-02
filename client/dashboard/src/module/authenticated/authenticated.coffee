angular.module 'picstreet.authenticated', [

	'picstreet.map'
	'picstreet.payment'

	'picstreet.customers'
	'picstreet.customer'

	'picstreet.photographers'
	'picstreet.albums'
	'picstreet.album'
	
]

.config ($stateProvider) ->

	$stateProvider

	.state 'authenticated',
		abstract: true
		templateUrl: 'authenticated.view.html'
		controller: "authenticatedCtrl"


.run ($state) ->

	for state in $state.get()
		if state.name.match ///authenticated.///

			state.resolve = {} unless state.resolve
			
			state.resolve.me = ($state, $location, $connect, $grant, $q) ->

				$connect.remember (me) ->

					if $state.grantedRoles is undefined or $grant.isGranted me.roles, state.grantedRoles
						console.log 'authorized', me
						return $q.resolve(me)

					else
						console.log 'unauthorized'
						$connect.logout()
						return $q.reject()

