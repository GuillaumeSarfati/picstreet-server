angular.module 'picstreet.directives'

.directive 'pictureUploader', ($rootScope, Picture)->

	restrict: 'E'
	templateUrl: 'picture-uploader.view.html'
	scope:
		album: '='
	link: ($scope, $element, $attrs) ->

		$scope.state = 'ready'
		$scope.newPictures = {}

		$scope.dropzoneConfig = 
			parallelUploads: 1
			maxFileSize: 30000000000
			autoDiscover: false
			url: __API_URL__ + '/api/Buckets/ppxpictures/upload'
			renameFilename: (filename) ->
				newfilename = $scope.album.id + '-' + new Date().getTime() + '.jpg';
				picture = 
					name: newfilename
					albumId: $scope.album.id
					photographerId: $rootScope.me.id
				
				console.log 'PICTURE : ', picture
					
				$scope.newPictures[filename] = picture

				return newfilename



		$scope.dropzoneEvents = 

			addedfile: (file) -> 
				$scope.state = 'loading'
				$scope.$apply() unless $scope.$$phase
				$scope.startTime = moment()
			totaluploadprogress: (a, b, c) ->
				$scope.percent = a.toFixed(2)
				$scope.$apply() unless $scope.$$phase

			queuecomplete: ->
				
				$scope.state = 'apply'
				pictures = []

				for key, picture of $scope.newPictures
					pictures.push picture

				Picture.createMany pictures
				.$promise
				.then (pictures) -> 
					console.log 'pictures : ', pictures
					
					setTimeout ->
						$scope.state = 'ready'
						$scope.$apply() unless $scope.$$phase
						
						for picture in pictures
							$scope.album.pictures.push picture

						$scope.newPictures = {}
					, 3000
			success: (file) ->

				console.log 'success : ', file

			error: (err) ->
				console.log 'error', err
				$scope.state = 'error'
				$scope.$apply() unless $scope.$$phase



