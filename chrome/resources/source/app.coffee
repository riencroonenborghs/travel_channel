app = angular.module "travelChannel", [
  "ngAria", 
  "ngAnimate", 
  "ngMaterial", 
  "ngMdIcons",
]

app.config ($mdThemingProvider) ->
  $mdThemingProvider.theme("default")
    .primaryPalette("blue")
    .accentPalette("green")

app.constant "SERVER", "http://www.travelchannel.com"
app.constant "EPISODES", "/shows/whats-new-on-travel-channel/articles/full-episodes"
app.service "Channel", [ "$http", "$q", "SERVER", "EPISODES", "$parse", ($http, $q, SERVER, EPISODES, $parse) ->
  service:
    episodesList: ->
      deferred = $q.defer()
      $http.get(SERVER+EPISODES).then (d) -> 
        links = $(d.data).find("section.topn-wrapper")
        list  = for item in links
          item          = $(item)
          _link         = $(item.find("h2 a"))
          _img          = $(item.find("img"))
          _description  = $(item.find(".topn-description"))[0].innerText.replace("Watch Full Episodes", "")
          { url: _link.attr('href'), name: _link.text(), image: _img.attr("src"), description: _description }
        deferred.resolve list
      deferred.promise
    episodes: (episodeItem) ->
      deferred = $q.defer()
      $http.get(SERVER+episodeItem.url).then (d) => 
        playlistItems = $(d.data).find(".videoplaylist-item")
        episodes      = for playlistItem in playlistItems
          data    = $(playlistItem).data().videoplaylistData
          episode = 
            title: data.title
            description: data.description
            smil: data.releaseUrl
          episode
        deferred.resolve episodes
      deferred.promise    
    videos: (episode) ->
      deferred = $q.defer()
      $http.get(episode.smil).then (d) ->
        list = []
        data = d.data.replace(/video/g, 'replacedvideo');
        for _switch, index in $(data).find("switch")
          if index == 0
            for _video in $(_switch).find("replacedvideo")
              srcRe = /src=\"(.+).mp4\"/
              widthRe = /width=\"(\d+)\"/
              heightRe = /height=\"(\d+)\"/
              console.debug srcRe.exec(video)
              video = $(_video)[0].outerHTML
              src = srcRe.exec(video)[1]
              width = widthRe.exec(video)[1]
              height = heightRe.exec(video)[1]
              list.push {src: src, width: width, height: height}
        deferred.resolve list
      deferred.promise
]    

app.controller "appController", ["$scope", "Channel",
($scope, Channel) ->
  $scope.views        = {episodesList: true, episodes: false}
  $scope.episodesList = null
  $scope.episodesItem = null
  $scope.episodes     = null
  $scope.videos       = null

  # start with episodes list
  $scope.episodesList = episodesList
  episodesList = ->
    $scope.views        = {episodesList: true, episodes: false}
    $scope.episodeItem  = null
    Channel.service.episodesList().then (episodesList) -> $scope.episodesList = episodesList
  episodesList()

  # episodes for episode item
  $scope.episodes = (episodeItem) ->
    $scope.views        = {episodesList: false, episodes: true}
    $scope.episodeItem  = episodeItem
    Channel.service.episodes(episodeItem).then (episodes) -> 
      $scope.episodes = episodes
]

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