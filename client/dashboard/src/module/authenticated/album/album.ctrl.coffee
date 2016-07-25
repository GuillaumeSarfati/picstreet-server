angular.module "picstreet.album"

.controller "albumCtrl", ($rootScope, $scope, Album, Picture, album) ->

	$scope.dropzone = {}
	$scope.newPictures = {}
	console.log $scope.album = album
	
	
	$scope.updateAlbum = (album) ->
		Album.upsert album
		.$promise
		.then (success) -> console.log 'success : ', success
		.catch (err) -> console.log 'err : ', err

	$scope.dropzoneConfig = 
		parallelUploads: 1
		maxFileSize: 30000000000
		autoDiscover: false
		renameFilename: (filename) ->
			console.log 'RENAME FILE config : ', filename
			
			newfilename = $scope.album.id + '-' + new Date().getTime() + '.jpg';
			picture = 
				name: newfilename
				albumId: $scope.album.id
			
			console.log 'PICTURE : ', picture
				
			$scope.newPictures[filename] = picture

			return newfilename

		url: 'http://localhost:3000/api/Buckets/ppxpictures/upload'


	$scope.dropzoneEvents = 

		addedfile: (file) -> console.log file
		success: (file) -> 

			

		error: (file, error) -> console.log file, error
		totaluploadprogress: (a, b , c) ->
			console.log a, b, c
		queuecomplete: -> 
			console.log 'upload finish'
			console.log 'create pictures'

			pictures = []

			for key, picture of $scope.newPictures
				
				pictures.push picture

			$scope.$apply unless $scope.$$phase
			
			console.log 'FUTURE PICTURES : ', pictures
			Picture.createMany pictures
			.$promise
			.then (pictures) -> 
				console.log 'pictures : ', pictures
				
				for picture in pictures
					$scope.album.pictures.push picture
				$scope.newPictures = []
				$scope.dropzone = undefined
				
			.catch (err) -> console.log 'err : ', err
			
