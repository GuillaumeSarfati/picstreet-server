angular.module 'picstreet.directives', []

.service '$grant', ->
	return $grant = 
		isGranted: (userRoles, grantedRoles) ->
			
			if userRoles
				for role in userRoles
					return true if role.name in grantedRoles
			return false
			
			grantedRoles = $parse($attr.ngGrant)($scope)
			userRoles = me.roles

			if $grant.isGranted userRoles, grantedRoles
				$element[0].style.display = 'block'


# .directive 'breadcrumb', ($rootScope, $parse) ->

# 	restrict: 'A'

# 	link: ($scope, $element, $attrs) ->

# 		console.log $parse($attrs.breadcrumb)($scope)
# 		$rootScope.$on '$stateChangeSuccess', (event, state)->
# 			switch state.name
# 				when 'authenticated.activities' then console.log 'Activity'
.directive 'ngGrant',($rootScope, $parse, $animate, $compile, $grant) ->
	multiElement: true,
	transclude: 'element',
	priority: 600,
	terminal: true,
	restrict: 'A',
	$$tlb: true,
	link: ($scope, $element, $attr, ctrl, $transclude) ->
				
		$rootScope.$watch 'me'
		, (me) ->
			if me and me.roles
				grantedRoles = $parse($attr.ngGrant)($scope)
				userRoles = me.roles

				if $grant.isGranted userRoles, grantedRoles
					unless childScope
						$transclude (clone, newScope) ->
							childScope = newScope;
							clone[clone.length++] = $compile.$$createComment('end ngGrant', $attr.ngGrant)

							block = clone: clone
							$animate.enter(clone, $element.parent(), $element)

				else 
					if previousElements
						previousElements.remove()
						previousElements = null
					
					if childScope
						childScope.$destroy()
						childScope = null

					if block
						previousElements = getBlockNodes block.clone
						
						$animate.leave previousElements
						.then ->
							previousElements = null
					 
						block = null

		, true





.config ($provide, $stateProvider) ->
	$provide.decorator '$state', ($delegate, $rootScope) ->
		$rootScope.$on '$stateChangeStart', (event, state, params) ->
			$delegate.grantedRoles = state.grantedRoles
		$delegate
			
.run ($state) ->

	for state in $state.get()
		
		if state.name.match ///authenticated.///

			state.resolve = {} unless state.resolve
			state.resolve.me = ($state, $location, $connect, $grant, $q) ->
				$connect.remember (me) ->
					console.info '[ ME ]', me
					if $state.grantedRoles is undefined or $grant.isGranted me.roles, $state.grantedRoles
						console.log 'authorized'
						return $q.resolve(me)

					else
						console.log 'unauthorized'
						$connect.logout()
						return $q.reject()
