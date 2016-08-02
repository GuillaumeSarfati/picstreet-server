angular.module "picstreet.activities"

.controller "activitiesCtrl", ($rootScope, $scope, $grant, Activity, me) ->

	filter = 
		order: 'creationDate DESC'
		limit: 100

	if $grant.isGranted me.roles, ['$administrator']
		filter.limit = 1000

	else if $grant.isGranted me.roles, ['$manager']
		filter.where = 
			'or': [
				{managerId: me.id}
				{photographerId: me.id}
			]

	else if $grant.isGranted me.roles, ['$photographer']
		filter.where = photographerId: me.id

	Activity.find filter: filter
	.$promise
	.then (activities) -> 
		console.info '[ ACTIVITIES ]', activities
		$scope.activities = activities
	.catch (err) -> console.log err
