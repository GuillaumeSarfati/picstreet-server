angular.module "picstreet.albums", []

.config ($stateProvider) ->

	$stateProvider

	.state 'authenticated.albums',
		url: '/albums'
		views:
			menuContent:
				templateUrl: 'albums.view.html'
				controller: 'albumsCtrl'

		resolve:

			albums: ($rootScope, Album) ->
				filter = 
					include: [
						{relation: 'pictures'}
					]
					order: 'date DESC'
				# if $grant.isGranted $rootScope.me.roles, ['$administrator'] 
				# 	filter.where = {}
				
				# else if $grant.isGranted $rootScope.me.roles, ['$manager']
				# 	filter.where = photographerId: inq: $rootScope.me.photographers.map (photographers) -> photographer.id 
				
				# else if $grant.isGranted $rootScope.me.roles, ['$photographer']
				# 	filter.where = photographerId: $rootScope.me.id
				
				return Album.find 
					filter: filter
				.$promise

	.state 'authenticated.reviews',
		url: '/reviews'
		views:
			menuContent:
				templateUrl: 'albums.view.html'
				controller: 'albumsCtrl'

		grantedRoles: ['$administrator']
		
		resolve:

			albums: ($rootScope, Album) ->
				filter = 
					where:
						status: 'review'
					include: [
						{relation: 'pictures'}
					]
					order: 'date DESC'
				# if $grant.isGranted $rootScope.me.roles, ['$administrator'] 
				# 	filter.where = {}
				
				# else if $grant.isGranted $rootScope.me.roles, ['$manager']
				# 	filter.where = photographerId: inq: $rootScope.me.photographers.map (photographers) -> photographer.id 
				
				# else if $grant.isGranted $rootScope.me.roles, ['$photographer']
				# 	filter.where = photographerId: $rootScope.me.id
				
				return Album.find 
					filter: filter
				.$promise

			

	return

.run ->
	return
