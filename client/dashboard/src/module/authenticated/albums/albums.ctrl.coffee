angular.module "picstreet.albums"

.controller "albumsCtrl", ($rootScope, $scope, $grant, Album) ->

	$scope.dates = {}
	$scope.today = moment().format('dddd DD MMMM YYYY')
	$scope.yesterday = moment().subtract(1, 'days').format('dddd DD MMMM YYYY')

	$scope.globalPotentiel = 0
	$scope.globalPurchase = 0
	$scope.globalPictures = 0

	filter = 
		include: [
			{relation: 'pictures'}
		]
		order: 'date DESC'

	photographersId = $rootScope.me.photographers.map (photographer) -> photographer.id
	photographersId.push $rootScope.me.id

	if $grant.isGranted $rootScope.me.roles, ['$administrator'] 
		filter.where = {}
	
	else if $grant.isGranted $rootScope.me.roles, ['$manager']
		filter.where = photographerId: inq: photographersId
	
	else if $grant.isGranted $rootScope.me.roles, ['$photographer']
		filter.where = photographerId: $rootScope.me.id
	
	Album.find 
		filter: filter
	.$promise
	.then (albums) -> 
		console.log 'albums : ', albums
		for album in albums
			$scope.dates[moment(album.date).format('dddd DD MMMM YYYY')] = {albums: [], purchase: 0, potentiel: 0, pictures: 0} unless $scope.dates[moment(album.date).format('dddd DD MMMM YYYY')]
			$scope.dates[moment(album.date).format('dddd DD MMMM YYYY')].albums.push album
			$scope.dates[moment(album.date).format('dddd DD MMMM YYYY')].pictures += album.pictures.length
			album.purchase = 0
			album.potentiel = 0
			
			for picture in album.pictures
				$scope.dates[moment(album.date).format('dddd DD MMMM YYYY')].potentiel += picture.price
				$scope.dates[moment(album.date).format('dddd DD MMMM YYYY')].purchase += picture.price if picture.purchase
				$scope.globalPotentiel += picture.price
				$scope.globalPurchase += picture.price if picture.purchase
				
				album.potentiel += picture.price
				album.purchase += picture.price if picture.purchase

		$scope.albums = albums
		$scope.$apply() unless $scope.$$phase

		console.log 'ALBUMS PURCHASE ', $scope.dates

	$scope.deleteAlbum = (album) ->
		Album.destroyById id: album.id
		.$promise
		.then (success) -> 
			$scope.albums.splice $scope.albums.indexOf(album), 1
			$scope.$apply() unless $scope.$$phase
			console.log 'success : ', success
		.catch (err) -> console.log 'err : ', err