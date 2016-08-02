angular.module 'picstreet'

.filter ->
	(date, format) ->
		moment(date).format(format)