angular.module 'picstreet.authenticated', [

	'picstreet.map'
	'picstreet.payment'

	'picstreet.customers'
	'picstreet.customer'

	'picstreet.photographers'
	'picstreet.albums'
	'picstreet.album'
	
]

.config ($stateProvider) ->

	$stateProvider

	.state 'authenticated',
    abstract: true
    templateUrl: 'authenticated.view.html'
    controller: "authenticatedCtrl"

