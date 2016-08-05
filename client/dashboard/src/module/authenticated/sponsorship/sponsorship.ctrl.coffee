angular.module "picstreet.sponsorship"

.controller "sponsorshipCtrl", ($rootScope, $scope, Photographer) ->

	$scope.sponsorship = (email) ->
		console.log 'sponsorship : ', email

		Photographer.sponsorship email: email
		.$promise
		.then (success) -> console.log 'success 1: ', success
		.catch (err) -> console.log 'err : ', err

		Photographer.sponsorship email
		.$promise
		.then (success) -> console.log 'success 2: ', success
		.catch (err) -> console.log 'err : ', err

		Photographer.sponsorship email: email, {}
		.$promise
		.then (success) -> console.log 'success 3: ', success
		.catch (err) -> console.log 'err : ', err