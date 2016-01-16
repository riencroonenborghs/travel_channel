app = angular.module "travelChannel.controllers", []

app.controller "appController", ["$scope", "NavbarFactory", ($scope, NavbarFactory) ->
  $scope.Navbar = new NavbarFactory
  $scope.Navbar.addTitle "TravelChannel"

  $scope.search =
    query: ""  
]

app.controller "ProgramsController", ["$scope", "$location", "TravelChannel",
($scope, $location, TravelChannel) ->
  $scope.Navbar.reset()
  $scope.Navbar.addTitle "TravelChannel"

  $scope.loading  = true
  $scope.programs = []

  TravelChannel.programs().then (programs) -> 
    $scope.loading = false
    $scope.programs = programs

  $scope.episodes = (program) -> $location.path "/episodes/#{program.name}/#{program.url}"
]

app.controller "EpisodesController", ["$scope", "$location", "$routeParams", "TravelChannel", "NavbarFactory",
($scope, $location, $routeParams, TravelChannel, NavbarFactory) ->  
  name = $routeParams.name
  $scope.Navbar.reset()
  $scope.Navbar.addLink "/programs"
  $scope.Navbar.addTitle name

  url             = $routeParams.url
  $scope.loading  = true
  $scope.episodes = []

  TravelChannel.episodes(url).then (episodes) ->
    $scope.loading = false
    $scope.episodes = episodes
]