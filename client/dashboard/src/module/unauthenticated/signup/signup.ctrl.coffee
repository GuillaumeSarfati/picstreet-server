angular.module "picstreet.signup"

.controller "signupCtrl", ($scope, $state, $connect) ->

	$scope.signup = (me) ->
		$connect.signup me, {}, ->
			$connect.login me, ->
				$connect.remember (me) ->
					$state.go 'authenticated.activities'

	$scope.back = ->
		$state.go 'login'
