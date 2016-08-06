angular.module "picstreet.sponsorship"

.controller "sponsorshipCtrl", ($rootScope, $scope, Photographer) ->
	$scope.photographer = 
		firstname:'photographer'
		email: 'photographer@picstreet.io'

	$scope.sponsorship = (photographer) ->
		console.log 'sponsorship : ', photographer

		Photographer.sponsorship photographer
		.$promise
		.then (success) -> console.log 'success 1: ', success
		.catch (err) -> console.log 'err : ', err
