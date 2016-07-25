angular.module "picstreet.albums"

.controller "albumsCtrl", (albums, $rootScope, $scope, Album) ->


	for album in albums
		album.purchase = 0
		
		console.log 'album name : ', album
		for picture in album.pictures
			purchase += picture.price if picture.purchase

	$scope.albums = albums
	$scope.$apply() unless $scope.$$phase

	console.log 'ALBUMS PURCHASE ', $scope.albums 
