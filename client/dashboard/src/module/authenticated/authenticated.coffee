angular.module 'picstreet.authenticated', [

	'picstreet.map'
	'picstreet.activities'

	'picstreet.payment'

	'picstreet.customers'
	'picstreet.customer'

	'picstreet.sponsorship'

	'picstreet.photographers'
	'picstreet.photographer'

	'picstreet.albums'
	'picstreet.album'
	
]

.config ($stateProvider) ->

	$stateProvider

	.state 'authenticated',
		abstract: true
		templateUrl: 'authenticated.view.html'
		controller: "authenticatedCtrl"
