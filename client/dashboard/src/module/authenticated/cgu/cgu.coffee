angular.module "picstreet.cgu", []

.config ($stateProvider) ->

	$stateProvider

	.state 'authenticated.cgu',
		url: '/cgu'
		views:
			menuContent:
				templateUrl: 'cgu.view.html'
				controller: 'cguCtrl'
		
		grantedRoles: [
			'$administrator'
			'$manager'
			'$photographer'
			'$new'
		]
		
		resolve: {}

	return

.run ->
	return
