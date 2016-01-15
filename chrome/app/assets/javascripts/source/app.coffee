app = angular.module "travelChannel", [
  "ngAria", 
  "ngAnimate", 
  "ngMaterial", 
  "ngMdIcons",
  "ngRoute"
  "travelChannel.controllers",
  "travelChannel.directives",
  "travelChannel.services",
  "travelChannel.factories"
]

app.config ($mdThemingProvider) ->
  $mdThemingProvider.theme("default")
    .primaryPalette("blue")
    .accentPalette("orange")

app.constant "SERVER", "http://www.travelchannel.com"
app.constant "EPISODES", "/video/full-episodes"

app.config ($routeProvider, $locationProvider) ->
  $routeProvider
    .when "/programs",
      templateUrl: "app/views/programs.html"
      controller: "ProgramsController"
    .when "/episodes/:name/:url*",
      templateUrl: "app/views/episodes.html"
      controller: "EpisodesController"
    .otherwise "/programs",
      templateUrl: "app/views/programs.html"
      controller: "ProgramsController"
  $locationProvider.html5Mode true