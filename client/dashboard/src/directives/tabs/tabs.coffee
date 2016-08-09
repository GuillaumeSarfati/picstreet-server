angular.module 'picstreet'

.directive 'tabsMenu', ->
	restrict: 'E'
	transclude: true
	templateUrl: 'tabs-menu.view.html'

	controller: ($scope) ->
		$scope.tabs = [] unless $scope.tabs
		$scope.$watch 'tabs', (tabs) ->
			$scope.currentTab = 0
		
		$scope.updateCurrentTab = (index) ->
			$scope.$parent.currentTab = $scope.currentTab = index
		
		return 

.directive 'tabsContent', ($parse)->
	restrict: 'E'
	transclude: true
	
	require:'^tabsMenu'
	scope:true

	templateUrl: 'tabs-content.view.html'

	link: ($scope, $element, $attrs, $ctrl) ->
		$scope.tab = $parse($attrs.title)($scope) or name: $attrs.title
		$scope.tabs.push $scope.tab
