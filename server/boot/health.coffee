moment = require 'moment'
module.exports = (server) ->
	server.get '/health', (req, res) ->
		console.log "[ #{moment().format('HH:mm:ss')} ] Web server health check is Ok"
		res.send 
			status: 200
			message: 'ok'