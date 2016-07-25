
module.exports = (Customer) ->

	require("#{__dirname}/customer/create.customer")(Customer)
	require("#{__dirname}/customer/password.customer")(Customer)
	require("#{__dirname}/customer/remember.customer.coffee")(Customer)

