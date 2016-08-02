angular.module 'picstreet'

.factory '$socket', (LoopBackAuth) ->


	console.log '$socket'

	id = LoopBackAuth.accessTokenId
	userId = LoopBackAuth.currentUserId
	
	socket = io.connect __API_URL__

	

	return socket
