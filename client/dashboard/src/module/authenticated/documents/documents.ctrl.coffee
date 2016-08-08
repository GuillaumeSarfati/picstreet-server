angular.module "picstreet.documents"

.controller "documentsCtrl", ($rootScope, $scope, $state, Photographer) ->

	$scope.$emit 'loading:hide', force:true
	$scope.$emit 'loading:lock'

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

		if $rootScope.me.identityDocumentId and $rootScope.me.societyDocumentId
			Photographer.verify()
			.$promise
			.then (success) -> 
				delete $rootScope.me
				$state.go 'authenticated.activities'
			.catch (err) -> console.log 'err : ', err

