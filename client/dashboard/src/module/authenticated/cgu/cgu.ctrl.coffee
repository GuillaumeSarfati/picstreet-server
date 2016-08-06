angular.module "picstreet.cgu"

.controller "cguCtrl", ($rootScope, $scope, LegalCategory, Legal) ->
	$scope.tabs = []
	$scope.currentTab= undefined
	LegalCategory.find 
		filter:
			include: [
				{
					relation:'legals'
					scope:
						order: 'position ASC'
				}
			]
	.$promise
	.then (category) -> $scope.tabs = category
	.catch (err) -> console.log 'err : ', err
	$scope.deleteLegal = (legal) ->
		if confirm 'Are you sure to delete ?'
			Legal.destroyById id: legal.id
			.$promise
			.then (success) -> 
				console.log 'success : ', success
				$scope.currentTab.legals.splice $scope.currentTab.legals.indexOf(legal), 1
			.catch (err) -> console.log 'err : ', err
	$scope.createLegal = (legal) ->
		Legal.create
			title: legal.title
			description: legal.description
			categoryId: $scope.currentTab.id
			position: $scope.currentTab.legals.length
		.$promise
		.then (legal) -> 
			$scope.currentTab.legals.push legal
			$scope.newLegal = {}

		.catch (err) -> console.log 'err : ', err

	$scope.dragControlListeners =
		accept: (sourceItemHandleScope, destSortableScope) ->
			# console.log 'sourceItemHandleScope : ', sourceItemHandleScope
			# console.log 'destSortableScope : ', destSortableScope
			return true
		itemMoved: (event) -> console.log 'item moved :'#, event
		orderChanged:(event) -> 
			console.log 'order changed :', event
			position = 0
			for legal in event.dest.sortableScope.modelValue
				legal.position = position++
				Legal.upsert legal
				.$promise
				.then (success) -> console.log 'success : ', success
				.catch (err) -> console.log 'err : ', err


		# containment: '#board'//optional param.
		# clone: true //optional param for clone feature.
		# allowDuplicates: false //optional param allows duplicates to be dropped.
