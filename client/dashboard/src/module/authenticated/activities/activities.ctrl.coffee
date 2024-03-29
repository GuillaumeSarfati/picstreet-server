angular.module "picstreet.activities"

.controller "activitiesCtrl", ($rootScope, $scope, $grant, Activity, PicturePurchase, me) ->

	$scope.win = 0

	filter = 
		order: 'creationDate DESC'
		limit: 100

	photographersIds = me.photographers.map (photographer) -> photographer.id
	photographersIds.push me.id

	if $grant.isGranted me.roles, ['$master', '$administrator']
		filter.include = ['photographer']
		filter.limit = 200

	else if $grant.isGranted me.roles, ['$manager']
		filter.where = photographerId: inq: photographersIds
		filter.include = ['photographer']

	else if $grant.isGranted me.roles, ['$photographer']
		filter.where = photographerId: me.id

	else if $grant.isGranted me.roles, ['$new']
		filter.where = photographerId: me.id

	PicturePurchase.find filter: filter
	.$promise
	.then (success) -> 
		for purchase in success
			if $grant.isGranted me.roles, ['$master', '$administrator']
					value = purchase.price / 100 * 30

			if $grant.isGranted me.roles, ['$manager', '$photographer']
				
				if purchase.photographerId is me.id
					value = purchase.price / 100 * 70

				if purchase.photographerId isnt me.id
					value = purchase.price / 100 * 10
					
			$scope.win = parseFloat((parseFloat($scope.win) + parseFloat(value)).toFixed(2))
			console.log 'value : ', value
			console.log 'win : ', $scope.win


	.catch (err) -> console.log 'err pp: ', err

	Activity.find filter: filter
	.$promise
	.then (activities) -> 
		console.info '[ ACTIVITIES ]', activities
		$scope.activities = activities
	.catch (err) -> console.log err
