angular.module "picstreet.signup"

.controller "signupCtrl", ($scope, $state, $connect) ->

	$scope.signup = (me) ->
		$connect.signup me
		, {}
		, (response) ->
			$state.go 'authenticated.map'

	$scope.back = ->
		$state.go 'login'
