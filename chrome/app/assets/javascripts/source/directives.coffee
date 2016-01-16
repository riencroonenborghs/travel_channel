app = angular.module "travelChannel.directives", []

app.directive "navbar", [->
  restrict: "E"
  scope:
    model: "="
  templateUrl: "app/views/navbar.html"
  controller: [ "$scope", "$location", ($scope, $location) ->
    $scope.go = (url) -> $location.path url
  ]
]

app.directive "videos", [->
  restrict: "E"
  scope:
    episode: "="
  transclude: true
  templateUrl: "app/views/videos.html"
  controller: [ "$scope", "TravelChannel", ($scope, TravelChannel) ->
    $scope.videos   = []
    $scope.loading  = true
    TravelChannel.videos($scope.episode.smilUrl).then (data) ->
      $scope.loading  = false
      $scope.videos   = data
  ]
]