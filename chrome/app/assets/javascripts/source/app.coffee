app = angular.module "travelChannel", [
  "ngAria", 
  "ngAnimate", 
  "ngMaterial", 
  "ngMdIcons",
  "travelChannel.controllers",
  "travelChannel.directives",
  "travelChannel.services"
]

app.config ($mdThemingProvider) ->
  $mdThemingProvider.theme("default")
    .primaryPalette("blue")
    .accentPalette("orange")

app.constant "SERVER", "http://www.travelchannel.com"
app.constant "EPISODES", "/video/full-episodes"
