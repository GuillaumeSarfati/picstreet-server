angular.module 'picstreet.directives'

.directive 'documentUploader', ($rootScope, Document)->

	restrict: 'E'
	templateUrl: 'document-uploader.view.html'
	scope:
		type: '@'
	link: ($scope, $element, $attrs) ->
		doc = undefined
		$scope.state = 'ready'
		if $rootScope.me["#{$scope.type}DocumentId"]
			$scope.state = 'success'

		$scope.$on 'documentUploader:reset', ->
			console.log 'receive'
			$scope.state = 'ready'

		$scope.dropzoneConfig = 
			parallelUploads: 1
			maxFileSize: 30000000000
			autoDiscover: false
			url: __API_URL__ + '/api/Buckets/photographers-documents/upload'
			renameFilename: (filename) ->
				console.log 'RENAME FILE config : ', filename
				
				doc =
					filename: "#{$scope.type}-#{new Date().getTime()}.jpg"
					ownerId: $rootScope.me.id
					type: $scope.type
					bucket: 'photographers-documents'
				
				return doc.filename



		$scope.dropzoneEvents = 

			addedfile: (file) -> 
				$scope.state = 'loading'
				$scope.$apply() unless $scope.$$phase
			success: (file) ->
				console.log 'file : ', file
				Document.create doc
				.$promise
				.then (success) -> 
					console.log 'me :', $rootScope.me
					$rootScope.me["#{$scope.type}DocumentId"] = success.id
					$rootScope.me.$save()
					.then (success) ->
						$scope.$emit "#{$scope.type}Document:success"
						console.log 'success update attr: ', success
					.catch (err) -> console.log 'err update attr: ', err

					console.log 'success : ', success
					$scope.state = 'success'
				.catch (err) ->
					console.log 'err : ', err
					$scope.state = 'error'
			error: (file) ->
				$scope.state = 'error'
				$scope.$apply() unless $scope.$$phase



