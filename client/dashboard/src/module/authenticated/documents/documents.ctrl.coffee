angular.module "picstreet.documents"

.controller "documentsCtrl", ($rootScope, $scope, $state, Photographer) ->

	
	$scope.verify = ->
		
		Photographer.verify()
		.$promise
		.then (success) -> 
			console.log 'success : ', success
			$rootScope.me.roles = []
			$rootScope.me.roles.push name: '$photographer'
			$state.go 'authenticated.activities'
		.catch (err) -> console.log 'err : ', err