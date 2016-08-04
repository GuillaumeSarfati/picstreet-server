angular.module "picstreet.albums"

.controller "albumsCtrl", (albums, $rootScope, $scope, Album) ->
	console.log 'albums : ', albums

	$scope.dates = {}
	$scope.today = moment().format('dddd DD MMMM YYYY')
	$scope.yesterday = moment().subtract(1, 'days').format('dddd DD MMMM YYYY')

	$scope.globalPotentiel = 0
	$scope.globalPurchase = 0
	$scope.globalPictures = 0

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