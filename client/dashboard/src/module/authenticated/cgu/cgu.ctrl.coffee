angular.module "picstreet.cgu"

.controller "cguCtrl", ($location, $anchorScroll, $rootScope, $scope, LegalCategory, Legal) ->

	$scope.currentTab = undefined

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
	.then (categories) -> $scope.categories = categories
	.catch (err) -> console.log 'err : ', err
	$scope.editLegal = (legal) ->

		$scope.newLegal = legal
		$location.hash 'editor'
		$anchorScroll()

	$scope.deleteLegal = (legal) ->
		if confirm 'Are you sure to delete ?'
			Legal.destroyById id: legal.id
			.$promise
			.then (success) -> 
				console.log 'success : ', success
				$scope.categories[$scope.currentTab].legals.splice $scope.categories[$scope.currentTab].legals.indexOf(legal), 1
			.catch (err) -> console.log 'err : ', err
	
	$scope.createLegal = (legal) ->
		
		unless legal.id
			create = true
			legal.categoryId = $scope.categories[$scope.currentTab].id
			legal.position = $scope.categories[$scope.currentTab].legals.length
		
		Legal.upsert legal
			
		.$promise
		.then (legal) -> 
			if create

				$scope.categories[$scope.currentTab].legals.push legal

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
