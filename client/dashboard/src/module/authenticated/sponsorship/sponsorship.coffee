angular.module "picstreet.sponsorship", []

.config ($stateProvider) ->

	$stateProvider

	.state 'authenticated.sponsorship',
		url: '/sponsorship/:id'
		views:
			menuContent:
				templateUrl: 'sponsorship.view.html'
				controller: 'sponsorshipCtrl'
		
		resolve: {}

	return

.run ->
	return
