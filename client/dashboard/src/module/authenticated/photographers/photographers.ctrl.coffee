angular.module "picstreet.photographers"

.controller "photographersCtrl", ($rootScope, $scope, $grant, Photographer) ->

	if $grant.isGranted $rootScope.me.roles, ['$administrator']
		filter = {}
	
	else if $grant.isGranted $rootScope.me.roles, ['$manager']
		filter = where: id: inq: $rootScope.me.photographers.map (photographer) -> photographer.id 

	Photographer.find filter: filter
	.$promise
	.then (photographers) -> 
		console.log 'photographers : ', photographers
		$scope.photographers = photographers
	.catch (err) -> console.log err

	$scope.deletePhotographer = (photographer) ->
		if confirm 'Are you sure to delete this photographer ?'
			Photographer.destroyById id: photographer.id
			.$promise
			.then (success) -> 
				console.log 'success : ', success
				$scope.photographers.splice $scope.photographers.indexOf(photographer), 1
			.catch (err) -> console.log 'err : ', err
