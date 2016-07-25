angular.module "picstreet.customers"

.controller "customersCtrl", ($rootScope, $scope, Customer) ->

	Customer.find {}
	.$promise
	.then (customers) -> $scope.customers = customers
	.catch (err) -> console.log err

