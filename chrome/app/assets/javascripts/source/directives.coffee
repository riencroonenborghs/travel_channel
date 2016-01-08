app = angular.module "travelChannel.directives", []

app.directive "videos", [->
  restrict: "E"
  scope:
    episode: "="
  transclude: true
  templateUrl: "videos.html"
  controller: [ "$scope", "Episodes", ($scope, Episodes) ->
    $scope.videos = []
    Episodes.videos($scope.episode.link).then (data) ->
      $scope.videos = data
  ]
]