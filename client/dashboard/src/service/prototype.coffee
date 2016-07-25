String.prototype.camelCaseToDash = ->
	@replace ///([A-Z])///g
	, ($1) ->
		"-"+$1.toLowerCase()

String.prototype.capitalize = ->
  "#{@charAt(0).toUpperCase()}#{@slice(1)}"

Array.prototype.rotate = (newfirstItem) ->
	newFirstIndex = @.indexOf newfirstItem
	first = @.slice newFirstIndex
	last = @.slice 0, newFirstIndex

	first.concat last



