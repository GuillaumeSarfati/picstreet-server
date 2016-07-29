angular.module "picstreet.map"

.controller "mapCtrl", ($rootScope, $scope, $picstreet, photographers, monuments) ->
	
	$scope.position = {}
	$scope.monument = {}
	$scope.loadPicture = false
	$scope.content = 'monument'

	# DROPZONE CONFIG ----------------------------
	
	$scope.dropzoneConfig = 
		parallelUploads: 1
		maxFileSize: 30000000000
		url: 'http://localhost:3000/api/Buckets/picstreet-location/upload'

	$scope.dropzoneEvents = 
		addedfile: (file) -> 
			$scope.loadPicture = true
			$scope.$apply() unless $scope.$$phase
		success: (file) -> 
			$scope.monument.picture = file.name
			$scope.$apply() unless $scope.$$phase
	
	# $PICSTREET CONFIG ----------------------------

	$scope.center = $picstreet.center

	$scope.createMonument = (monument) ->
		$picstreet.center $scope.position, 8
		$picstreet.createMonumentInBdd monument
	
	$scope.updateMonument = (monument) ->
		if confirm "Are you sur to update #{monument.name} ?"
			$picstreet.updateMonumentInBdd monument
			$scope.monument = {}
			
	$scope.deleteMonument = (monument) ->
		if confirm "Are you sur to delete #{monument.name} ?"
			$picstreet.deleteMonumentInBdd monument
			$scope.monument = {}

	$scope.center = $picstreet.center
	
	$scope.monuments = monuments
	$scope.photographers = photographers

	console.info '[ PHOTOGRAPHERS ]', photographers
	console.info '[ MONUMENTS ]', monuments

	$scope.$on 'monument:click', (e, monument) ->
		$picstreet.center monument
		$scope.monument = monument

	$picstreet.init 'pk.eyJ1IjoicGl4ZXI0MiIsImEiOiJjaW91cDRqaGUwMDQ5dnRramp6cGkwMWh0In0.OpoxVVl38hLmP9XG2lk26w'
	
	$picstreet.map = $picstreet.createMap
		center: 
			lat: 48.8534100
			lng: 2.3488000
		zoom: 11

	$picstreet.map.on 'click', (e) ->
		
		if $scope.content is 'monument'
			$scope.monument.lat = e.lngLat.lat
			$scope.monument.lng = e.lngLat.lng
			$scope.$apply() unless $scope.$$phase

	$picstreet.createPhotographers photographers
	$picstreet.createMonuments monuments
		
	$rootScope.$on 'photographer:position:update', (e, position) ->

		$picstreet.updatePhotographerPosition
			photographerId: position.photographerId
			position: position

	return
		
