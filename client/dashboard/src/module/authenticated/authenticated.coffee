angular.module 'picstreet.authenticated', [

	'picstreet.documents'
	'picstreet.cgu'
	
	'picstreet.activities'

	'picstreet.payment'
	'picstreet.map'

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
