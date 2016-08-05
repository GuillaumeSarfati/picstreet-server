async = require 'async'
token = require 'rand-token'

module.exports = (Photographer) ->


	Photographer.afterRemote 'create', (ctx, instance, next) ->
		console.log 'after create photographer'
		RoleMapping = Photographer.app.models.RoleMapping
		RoleMapping.create
			principalType: RoleMapping.USER,
			principalId: instance.id
			roleId: '57a4962584cffe609fcab3d6'
		, (err, principal) ->
			console.log err, principal
			next()


	Photographer.sponsorship = (req, email, callback) ->
		
		RoleMapping = Photographer.app.models.RoleMapping
		Activity = Photographer.app.models.Activity

		console.log req.accessToken.userId
		console.log email
		
		manager = undefined
		newPhotographer =  undefined
		
		async.waterfall [
			
			(done) ->

				Photographer.findOne 
					where: id: req.accessToken.userId
					include: ['roles']
				, done

			(photographer, done) ->
				manager = photographer
				for role in photographer.roles()
					if role.name is '$manager'
						return done null, role
				return done null,
					principalType: RoleMapping.USER,
					principalId: photographer.id
					roleId: '579fccf27fbbd463527e4956'

			(role, done) ->

				unless role.id
					RoleMapping.create role
						
					, (err, roleMapping) -> 
						done err
				done null

			(done) ->
				console.log 'password : ', password = token.generate 5, '2345678923456789ABCDEFGHJKLMNPQRSTUVWXYZ'
				Photographer.create
					email: email
					password: password
					managerId: req.accessToken.userId
				, done
			

			(photographer, done) ->
				newPhotographer = photographer

				RoleMapping.create
					principalType: RoleMapping.USER,
					principalId: photographer.id
					roleId: '57a4962584cffe609fcab3d6'
				, done					
			
			(roleMapping, done) ->
				Activity.create
					type: 'send:sponsorship'
					photographerId: manager.id
					newPhotographer: newPhotographer
				, done

			(action, done) ->
				Activity.create
					type: 'receive:sponsorship'
					photographerId: newPhotographer.id
					manager: manager
				, done
		], callback


	Photographer.remoteMethod 'sponsorship',
		accepts: [
			{
				arg: 'req'
				type: 'object'
				http: source: 'req'
			}
			{
				arg: 'email'
				type: 'string'
				required: true
				http: source: 'path'
			}
		],
		returns: {arg: 'response', type: 'object', root: true},
		http: {path: '/sponsorship/:email', verb: 'post'}
			
	