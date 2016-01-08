app = angular.module "travelChannel.controllers", [
  "travelChannel.services"
]

app.controller "appController", ["$scope", "Episodes",
($scope, Episodes) ->
  $scope.loading = true
  $scope.programs = []

  Episodes.index().then (data)->
    $scope.loading = false
    $scope.programs = data

  $scope.search =
    query: ""  
]