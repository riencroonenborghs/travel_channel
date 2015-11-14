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
    .accentPalette("green")

app.constant "SERVER", "http://www.travelchannel.com"
app.constant "EPISODES", "/shows/whats-new-on-travel-channel/articles/full-episodes"
