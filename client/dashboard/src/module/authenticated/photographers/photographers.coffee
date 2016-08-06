angular.module "picstreet.photographers", []

.config ($stateProvider) ->

	$stateProvider

	.state 'authenticated.photographers',
		url: '/photographers'
		views:
			menuContent:
				templateUrl: 'photographers.view.html'
				controller: 'photographersCtrl'
		
		grantedRoles: ['$administrator', '$manager']
		resolve: {}

	return

.run ->
	return
