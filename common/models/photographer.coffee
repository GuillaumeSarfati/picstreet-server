async = require 'async'
token = require 'rand-token'

module.exports = (Photographer) ->

	Photographer.addRole = (roleName, photographerId, callback) ->
		RoleMapping = Photographer.app.models.RoleMapping
		Role = Photographer.app.models.Role

		async.waterfall [
			(done) ->
				Role.findOne
					where:
						name: roleName
				, done
			(role, done) ->
				RoleMapping.create 
					principalType: RoleMapping.USER,
					principalId: photographerId
					roleId: role.id
				, done
		], callback

	Photographer.removeRole = (roleName, photographerId, callback) ->
		Role = Photographer.app.models.Role
		RoleMapping = Photographer.app.models.RoleMapping

		async.waterfall [
			(done) ->
				Role.findOne
					where:
						name: roleName
				, done

			(role, done) ->
				console.log 'before delete'
				RoleMapping.destroyAll
				
					principalType: RoleMapping.USER,
					principalId: photographerId
					roleId: role.id
				, done
		], (err, role) ->
			console.log err, role
			callback err, role

	Photographer.afterRemote 'create', (ctx, instance, callback) ->
		Photographer.addRole '$new'
		, instance.id
		, -> callback()

	Photographer.sponsorship = (req, newPhotographer, callback) ->
		
		RoleMapping = Photographer.app.models.RoleMapping
		Activity = Photographer.app.models.Activity

		manager = undefined
		
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
				# password = token.generate 5, '2345678923456789ABCDEFGHJKLMNPQRSTUVWXYZ'
				Photographer.create
					email: newPhotographer.email
					firstname: newPhotographer.firstname
					lastname: newPhotographer.lastname
					password: 'azerty'
					managerId: req.accessToken.userId
				, done
			

			(photographer, done) ->
				console.log 'before add role'
				newPhotographer = photographer
				Photographer.addRole '$new'
				, photographer.id
				, done
			
			(roleMapping, done) ->
				console.log 'after add role'
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
				arg: 'photographer'
				type: 'object'
				required: true
				http: source: 'body'
			}
		],
		returns: {arg: 'response', type: 'object', root: true},
		http: {path: '/sponsorship', verb: 'post'}
	
	Photographer.verify = (req, callback) ->
		
		RoleMapping = Photographer.app.models.RoleMapping
		
		Photographer.findOne 
			where: id: req.accessToken.userId
			include: ['roles']
		, (err, photographer) ->
			
			if photographer.roles()[0].name isnt '$new'
				err = new Error
				err.status = 405
			
			if err then return callback err

			async.waterfall [
			
				(done) ->
					Photographer.removeRole '$new'
					, photographer.id
					, done

				(response, done) ->
					Photographer.addRole '$photographer'
					, photographer.id
					, done
			
			], callback



	Photographer.remoteMethod 'verify',
		accepts: [
			{
				arg: 'req'
				type: 'object'
				http: source: 'req'
			}
		],
		returns: {arg: 'response', type: 'object', root: true},
		http: {path: '/verify', verb: 'post'}
			
	