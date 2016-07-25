angular.module "picstreet.album", ['ngDropzone']

.config ($stateProvider) ->

	$stateProvider

	.state 'authenticated.album',
		url: '/album/:id'
		views:
			menuContent:
				templateUrl: 'album.view.html'
				controller: 'albumCtrl'

		resolve: 

			album: (Album, $stateParams) ->

				Album.findOne 
					filter:
						where: 
							id: $stateParams.id
						include: 'pictures'

	return

.run ->
	return
