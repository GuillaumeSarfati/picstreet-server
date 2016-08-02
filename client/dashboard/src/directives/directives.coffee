angular.module 'picstreet.directives', []

.service '$grant', ->
	return $grant = 
		isGranted: (userRoles, grantedRoles) ->
			if userRoles
				for role in userRoles
					return true if role.name in grantedRoles
			return false


.directive 'ngGrant', ($rootScope, $parse, $grant) ->
	priority:999
	restrict: 'A'
	
	link: ($scope, $element, $attr) ->
		$element[0].style.display = 'none'

		$rootScope.$watch 'me', (me)->
			
			grantedRoles = $parse($attr.ngGrant)($scope)
			userRoles = me.roles

			if $grant.isGranted userRoles, grantedRoles
				$element[0].style.display = 'block'

.run ($state) ->

	for state in $state.get()
		if state.name.match ///authenticated.///

			state.resolve = {} unless state.resolve
			
			state.resolve.me = ($state, $location, $connect, $grant, $q) ->

				$connect.remember (me) ->

					if $state.grantedRoles is undefined or $grant.isGranted me.roles, state.grantedRoles
						console.log 'authorized', me
						return $q.resolve(me)

					else
						console.log 'unauthorized'
						$connect.logout()
						return $q.reject()
