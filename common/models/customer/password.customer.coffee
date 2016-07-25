crypto = require 'crypto'

module.exports = (Customer) ->

	Customer.on 'resetPasswordRequest', (info) ->

		AccessCode = Customer.app.models.AccessCode
		Email = Customer.app.models.Email
		
		password = AccessCode.token 6
		updatedPassword = password

		info.user.updateAttributes
      password: updatedPassword
    , (err, customer) ->
			Email.send
				to: info.user.email,
				from: "password@picstreet.io",
				subject: "[ PicStreet ] Reset your password",
				text: "Hello your temporary password is: #{password}"
			 

		
	Customer.updatePassword = (req, passwords, callback) ->
		console.log '---------------------'
		console.log '-  UPDATE PASSWORD  -'
		console.log '---------------------'

		Customer.findOne where: id: req.accessToken.userId
		, (err, customer) ->

			customer.hasPassword passwords.oldPassword, (err, isMatch) ->
				
				if err or isMatch is false
					callback 
						status: 409
						message: 'Bad password'
				
				else
					customer.password = passwords.newPassword
					customer.save()

					callback null, update: true

				


	Customer.remoteMethod 'updatePassword',
		accepts: [
			{
				arg: 'req'
				type: 'object'
				http: source: 'req'
			}
			{
				arg: 'passwords'
				type: 'object'
				http: source: 'body'
			}
			
		]
		returns:
			root: true
			arg: 'response'
			type: 'object'
		http:
			verb: 'post'
			path: '/update-password'
			errorStatus: 409
