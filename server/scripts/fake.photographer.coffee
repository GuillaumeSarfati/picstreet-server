
server = require '../server'
users = require('../data/users.json').users
moment = require('moment')
async = require 'async'
crypto = require 'crypto'


Photographer = server.models.Photographer
Position = server.models.Position
Location = server.models.Location

Photographer.create
	email: 'fake.photographer.9@picstreet.io'
	password: 'azerty1531'
	firstname: 'Fake'
	lastname: 'Photographer'
, (err, photographer) ->
	console.log err, photographer
	Position.create
		coord: 
			lat: 48.87493348353615
			lng: 2.2620677947998047
		photographerId: photographer.id
		available: true
	, (err, position) ->
		console.log err, position
