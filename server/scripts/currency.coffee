server  = require '../server.coffee'
moment = require 'moment'

Currency = server.models.Currency

Currency.sync (err, currencies) ->
	console.log "CRON: #{moment().format 'dddd DD MMMM HH:mm:ss' } > Currencies up to date."
	process.exit 0

# client.on 'connect', -> console.log 'connect'
# client.on 'error', -> console.log 'error'
# client.on 'reconnecting', -> console.log 'reconnecting'
# client.on 'drain', -> console.log 'drain'
# client.on 'drain', -> console.log 'drain'
# client.on 'idle', -> console.log 'idle'
