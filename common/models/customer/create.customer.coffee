async = require 'async'
token = require 'rand-token'

module.exports = (Customer) ->

  Customer.beforeRemote 'create', (ctx, customers, next) ->
    if ctx.req.body.length
      for customer in ctx.req.body
        unless customer.password
          customer.password = 'azerty' 
          #token.generate 5, '1234567890'
          # console.log 'GENERATE PASSWORD', customer.password

    next()

  Customer.afterRemote 'create', (ctx, customers, next) ->

    customers = [customers] unless customers.length
    
    async.waterfall [
      
      (done) ->

        async.map customers
        , Customer.createStripeCustomer
        , done
      
      (customers, done) ->
        
        async.map customers
        , (customer, asyncCallback) -> 
          customer.save asyncCallback
        , done

    ], next

  Customer.createStripeCustomer = (customer, callback) ->
    stripe = require('stripe')(Customer.app.settings.stripe.secretKey)
    stripe.customers.create
      description: customer.id.toString()
      email: customer.email
    , (err, stripeCustomer) ->

      customer.stripeId = stripeCustomer.id
      callback err, customer
     

  
  # Customer.associateTopicArn = (customer, callback) ->
  #   Sns = Customer.app.models.Sns

  #   Sns.createTopic Name: customer.id.toString()
  #   , (err, topic) ->
  #     customer.topicArn = topic.TopicArn
  #     callback err, customer

  

