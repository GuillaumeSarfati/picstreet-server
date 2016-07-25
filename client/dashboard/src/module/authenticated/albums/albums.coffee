angular.module "picstreet.albums", []

.config ($stateProvider) ->

  $stateProvider

  .state 'authenticated.albums',
    url: '/albums'
    views:
      menuContent:
        templateUrl: 'albums.view.html'
        controller: 'albumsCtrl'

    resolve:

    	albums: (Album) ->
    		Album.find 
    			filter:
    				include: [
              {
                relation: 'pictures' 
              }
            ]

  return

.run ->
  return
