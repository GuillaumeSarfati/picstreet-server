# redis = require 'redis'
# async = require 'async'
# fx = require 'money'

# OpenExchangeRates = require 'open-exchange-rates'

# oxr = new OpenExchangeRates app_id: 'xxxxxxxxx'

module.exports = (Currency) ->

		
# 	Currency.list = ->
# 		[
# 			'AED','AFN','ALL','AMD','ANG','AOA','ARS','AUD','AWG','AZN','BAM','BBD','BDT','BGN',
# 			'BHD','BIF','BMD','BND','BOB','BRL','BSD','BTC','BTN','BWP','BYR','BZD','CAD','CDF',
# 			'CHF','CLF','CLP','CNY','COP','CRC','CUC','CUP','CVE','CZK','DJF','DKK','DOP','DZD',
# 			'EEK','EGP','ERN','ETB','EUR','FJD','FKP','GBP','GEL','GGP','GHS','GIP','GMD','GNF',
# 			'GTQ','GYD','HKD','HNL','HRK','HTG','HUF','IDR','ILS','IMP','INR','IQD','IRR','ISK',
# 			'JEP','JMD','JOD','JPY','KES','KGS','KHR','KMF','KPW','KRW','KWD','KYD','KZT','LAK',
# 			'LBP','LKR','LRD','LSL','LTL','LVL','LYD','MAD','MDL','MGA','MKD','MMK','MNT','MOP',
# 			'MRO','MTL','MUR','MVR','MWK','MXN','MYR','MZN','NAD','NGN','NIO','NOK','NPR','NZD',
# 			'OMR','PAB','PEN','PGK','PHP','PKR','PLN','PYG','QAR','RON','RSD','RUB','RWF','SAR',
# 			'SBD','SCR','SDG','SEK','SGD','SHP','SLL','SOS','SRD','STD','SVC','SYP','SZL','THB',
# 			'TJS','TMT','TND','TOP','TRY','TTD','TWD','TZS','UAH','UGX','USD','UYU','UZS','VEF',
# 			'VND','VUV','WST','XAF','XAG','XAU','XCD','XDR','XOF','XPD','XPF','XPT','YER','ZAR',
# 			'ZMK','ZMW','ZWL'
# 		]


	
# 	Currency.getAll = (callback) ->
		
# 		client = redis.createClient
# 			host: Currency.app.datasources.RedisDb.settings.host
# 			port: Currency.app.datasources.RedisDb.settings.port

# 		client.on 'ready', ->
# 			async.map Currency.list()
# 			, (name, callback) -> 

# 				client.get name, (err, value) ->
# 					callback err,
# 						name: name
# 						value: value
# 			, (err, currencies) ->
# 				obj = {}

# 				for currency in currencies
# 					obj[currency.name] = currency.value
# 				callback err, obj

# 	Currency.remoteMethod 'getAll',
# 		description: "List currencies available with value"
# 		returns:
# 			arg: 'response'
# 			type: 'object'
# 			root: true
# 		http:
# 			verb: 'get'
# 			path: '/'

# 	Currency.sync = (callback) ->

# 		client = redis.createClient
# 			host: Currency.app.datasources.RedisDb.settings.host
# 			port: Currency.app.datasources.RedisDb.settings.port

# 		client.on 'ready', ->
# 			oxr.latest ->
# 				fx.base = 'USD'
# 				fx.rates = oxr.rates
# 				for rate of oxr.rates
# 					# oxr.rates[rate] = fx(oxr.rates[rate]).from('EUR').to('USD').toFixed(2)
# 					client.set rate, oxr.rates[rate]
# 				callback null, oxr.rates

# 	Currency.remoteMethod 'sync',
# 		description: "Sync currencies stored in Redis server with open exchange rates"
# 		returns:
# 			arg: 'response'
# 			type: 'object'
# 		http:
# 			verb: 'get'
# 			path: '/sync'


			
