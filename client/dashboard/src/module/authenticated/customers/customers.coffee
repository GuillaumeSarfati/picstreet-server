angular.module "picstreet.customers", []

.config ($stateProvider) ->

	$stateProvider

	.state 'authenticated.customers',
		url: '/customers'
		views:
			menuContent:
				templateUrl: 'customers.view.html'
				controller: 'customersCtrl'
				
	return

.run ->
	return
