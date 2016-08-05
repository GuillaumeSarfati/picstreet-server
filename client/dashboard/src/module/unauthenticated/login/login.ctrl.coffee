angular.module "picstreet.login"

.controller "loginCtrl", ($scope, $state, $connect)->

	$scope.me = 
		email: 'photographer@picstreet.io'
		password: 'azerty'

	$scope.login = (me) ->
		$connect.login me, (accessToken) ->
			$connect.remember (me) -> 
				$state.go 'authenticated.activities' if me

	$scope.signup = ->
		$state.go 'signup'
