angular.module "picstreet.login"

.controller "loginCtrl", ($scope, $state, $connect)->

	$scope.me = 
		email: 'manager@picstreet.io'
		password: 'azerty'

	$scope.login = (me) ->
		$connect.login me, (accessToken) ->
			$connect.remember (me) -> 
				$state.go 'authenticated.map' if me

	$scope.signup = ->
		$state.go 'signup'
