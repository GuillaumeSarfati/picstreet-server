loopback      = require 'loopback'
boot          = require 'loopback-boot'
moment        = require 'moment'

app           = module.exports = loopback()

app.start = ->
	# start the web server
	app.listen ->
		app.emit 'started'
		console.log "[ #{moment().format('HH:mm:ss')} ] Pixer server listening at : #{app.get('url')}"

# Bootstrap the application, configure models, datasources and middleware.
# Sub-apps like REST API are mounted via boot scripts.
boot app, __dirname, (err) ->
	
	# app.use(loopback.session({ secret: 'keyboard cat' }))
	
	if err
		throw err

	# start the server if `$ node server.js`
	if require.main == module
		app.io = require('socket.io')(app.start())
	return

