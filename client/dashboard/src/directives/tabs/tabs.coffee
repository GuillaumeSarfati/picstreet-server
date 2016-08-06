angular.module 'picstreet'

.directive 'tabsMenu', ->
	restrict: 'E'
	transclude: true
	templateUrl: 'tabs-menu.view.html'

	controller: ($scope) ->
		$scope.$watch 'tabs', (tabs) ->
			if tabs and tabs.length
				$scope.$parent.currentTab =  $scope.currentTab = tabs[0]

		
		$scope.updateCurrentTab = (tab) ->
			$scope.$parent.currentTab = $scope.currentTab = tab
		
		return 

.directive 'tabsContent', ($parse)->
	restrict: 'E'
	transclude: true
	
	require:'^tabsMenu'
	scope:true

	templateUrl: 'tabs-content.view.html'

	link: ($scope, $element, $attrs, $ctrl) ->
		$scope.tab = $parse($attrs.title)($scope)
