angular.module "picstreet.customer"

.controller "customerCtrl", (LinkBetweenAlbumAndCustomer, $rootScope, $scope, $stateParams, Customer, Album) ->

	Customer.findOne 
		filter: 
			where:
				id: $stateParams.id
			include: 'albums'
	.$promise
	.then (customer) -> 

		console.log customer
		$scope.customer = customer

	.catch (err) -> 

		console.log err


	$scope.createAlbum = (name, description, customer) ->

		Album.create
			name: name
			description: description
			customerId: customer.id
		.$promise
		.then (album) -> 
			$scope.customer.albums.push album
			
			LinkBetweenAlbumAndCustomer.create
				customerId: customer.id
				albumId: album.id
			.$promise
			.then (success) -> console.log 'success : ', success
			.catch (err) -> console.log 'err : ', err
		.catch (err) -> console.log 'err : ', err

