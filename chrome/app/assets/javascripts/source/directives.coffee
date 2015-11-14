app = angular.module "travelChannel.directives", []

app.directive "episodeVideos", [->
  restrict: "E"
  scope:
    episode: "="
  transclude: true
  templateUrl: "videos.html"
  controller: [ "$scope", "Channel", ($scope, Channel) ->
    $scope.videos = []
    Channel.service.videos($scope.episode).then (videos) ->
      $scope.videos = videos
  ]
]