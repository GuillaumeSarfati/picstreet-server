request = require 'request'

request.get 'http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=awesome'
, (err, result) ->
	console.log err, result.body
	process.exit 0