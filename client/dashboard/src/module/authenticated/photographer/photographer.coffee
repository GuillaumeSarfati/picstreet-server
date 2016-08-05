angular.module "picstreet.photographer", []

.config ($stateProvider) ->

	$stateProvider

	.state 'authenticated.photographer',
		url: '/photographer/:id'
		views:
			menuContent:
				templateUrl: 'photographer.view.html'
				controller: 'photographerCtrl'
		
		resolve: 

			photographer: (Photographer, $stateParams) ->

				Photographer.findOne
					filter:
						where: 
							id: $stateParams.id
						include: ['manager']
				.$promise

	return

.run ->
	return
