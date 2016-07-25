angular.module "picstreet.map"

.controller "mapCtrl", ($picstreet, $scope, photographers, monuments) ->
	
	$scope.position = {}
	$scope.monument = {}
	$scope.loadPicture = false
	$scope.content = 'monument'

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
	
	$scope.center = $picstreet.center
	
	$scope.monuments = monuments
	$scope.photographers = photographers

	console.info '[ PHOTOGRAPHERS ]', photographers
	console.info '[ MONUMENTS ]', monuments

	$scope.$on 'monument:click', (e, monument) ->
		$picstreet.center monument
		$scope.monument = monument
	# $scope.reserve = $picstreet.reserve
		
	# $cordovaGeolocation
	# .getCurrentPosition()
	# .then (position) ->
		
	# 	$picstreet.setCurrentPosition
	# 		lat: position.coords.latitude
	# 		lng: position.coords.longitude
		
	map = $picstreet.createMap
		center: 
			lat: 48.8534100
			lng: 2.3488000
		zoom: 11

	map.on 'click', (e) ->
		if $scope.content is 'monument'
			$scope.monument.lat = e.lngLat.lat
			$scope.monument.lng = e.lngLat.lng
			$scope.$apply() unless $scope.$$phase

	$picstreet.createPhotographers photographers
	$picstreet.createMonuments monuments
		
	# 	$picstreet.createCustomer
	# 		center:
	# 			lat: position.coords.latitude
	# 			lng: position.coords.longitude

	# $scope.$on "$ionicSlides.sliderInitialized", (event, data) ->
	# 	$scope.slider = data.slider

	# $scope.$on "$ionicSlides.slideChangeEnd", (event, data) ->

	# 	console.log 'SLIDE CHANGED : ', data.slider.activeIndex - 1
	# 	if data.slider.activeIndex
	# 		$scope.center($scope.monuments[data.slider.activeIndex - 1])
	# 	else
	# 		$scope.center $picstreet.getCurrentPosition()

	# $rootScope.$on 'customer:position:update', (e, position) ->
	# 	$picstreet.updateCustomerPosition position
	# 	$picstreet.center position.coord

	# $rootScope.$on 'photographer:position:update', (e, position) ->

 # 		$picstreet.updatePhotographerPosition
 # 			photographerId: position.photographerId
 # 			position: position
			
