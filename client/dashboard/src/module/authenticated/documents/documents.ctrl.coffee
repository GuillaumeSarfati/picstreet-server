angular.module "picstreet.documents"

.controller "documentsCtrl", ($rootScope, $scope, $state, Photographer) ->

	$scope.$on "identityDocument:success", ->
		$scope.identityDocumentMissing = false

	$scope.$on "societyDocument:success", ->
		$scope.societyDocumentMissing = false

	$scope.reset = ->
		$rootScope.me.identityDocumentId = null
		$rootScope.me.societyDocumentId = null
		$rootScope.me.$prototype$updateAttributes()
		.then (success) -> 
			console.log 'success : ', success
			$scope.$broadcast 'documentUploader:reset'
		.catch (err) -> console.log 'err : ', err

	$scope.verify = ->

		unless $rootScope.me.identityDocumentId
			$scope.identityDocumentMissing = true
		unless $rootScope.me.societyDocumentId
			$scope.societyDocumentMissing = true

		unless $scope.identityDocumentMissing and $scope.societyDocumentMissing
			Photographer.verify()
			.$promise
			.then (success) -> 
				$rootScope.me.roles = []
				$rootScope.me.roles.push name: '$photographer'
				$state.go 'authenticated.activities'
			.catch (err) -> console.log 'err : ', err

