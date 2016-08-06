angular.module "picstreet.documents", []

.config ($stateProvider) ->

	$stateProvider

	.state 'authenticated.documents',
		url: '/documents'
		views:
			menuContent:
				templateUrl: 'documents.view.html'
				controller: 'documentsCtrl'
		
		grantedRoles : ['$new']
		resolve: {}

	return

.run ->
	return
