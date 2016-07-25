angular.module "picstreet.photographers"

.controller "photographersCtrl", ($rootScope, $scope, Photographer) ->

	Photographer.find {}
	.$promise
	.then (photographers) -> $scope.photographers = photographers
	.catch (err) -> console.log err

