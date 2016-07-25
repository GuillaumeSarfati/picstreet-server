module.exports = (server) ->

	# # ----------------------------------
	# # SOCKET GLOSSARY
	# # ----------------------------------
	# #
	# # socket.broadcast.emit # OTHER USERS
	# # socket.emit # CURRENT USER
	# # app.io.sockets.emit # ALL USERS

	server.once 'started', ->

		app = server
		app.customer = {}
		
		app.io.sockets.on 'connection', (socket, data) ->

			console.log 'SOCKET CONNECTION'


