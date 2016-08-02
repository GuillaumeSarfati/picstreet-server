angular.module "picstreet.activities", []

.config ($stateProvider) ->

	$stateProvider

	.state 'authenticated.activities',
		url: '/activities'
		views:
			menuContent:
				templateUrl: 'activities.view.html'
				controller: 'activitiesCtrl'
		
		grantedRoles: ['$administrator']

		resolve: {}
	return

.run ->
	return
