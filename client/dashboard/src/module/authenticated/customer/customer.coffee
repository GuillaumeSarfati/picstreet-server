angular.module "picstreet.customer", []

.config ($stateProvider) ->

	$stateProvider

	.state 'authenticated.customer',
		url: '/customer/:id'
		views:
			menuContent:
				templateUrl: 'customer.view.html'
				controller: 'customerCtrl'
		resolve: {}
	return

.run ->
	return
