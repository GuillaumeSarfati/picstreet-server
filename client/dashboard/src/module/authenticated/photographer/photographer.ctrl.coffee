angular.module "picstreet.photographer"

.controller "photographerCtrl", ($rootScope, $scope, photographer, Photographer) ->

	$scope.photographer = photographer

	$scope.updatePhotographer = (photographer) ->

		photographer.$prototype$updateAttributes()
		.then (success) -> console.log 'success : ', success
		.catch (err) -> console.log 'err : ', err

