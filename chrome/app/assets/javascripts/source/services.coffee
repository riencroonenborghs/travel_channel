app = angular.module "travelChannel.services", []

app.service "TravelChannel", [ "$http", "$q", "SERVER", "EPISODES", ($http, $q, SERVER, EPISODES) ->
  service =
    programs: ->
      deferred = $q.defer()
      $http.get(SERVER+EPISODES).then (d) ->
        programs = []
        for item in $(d.data).find(".fullEpisode")
          program = 
            name: $(item).find(".jukebox-header h2").html()
            url: $(item).find(".jukebox-header .jukebox-header-moreText").attr("href")
            image: $(item).find(".jukebox-inner .jukebox-item-media img").attr("src")
          programs.push program if program.name
        deferred.resolve programs
      deferred.promise
    episodes: (url) ->
      deferred = $q.defer()
      $http.get(SERVER+url).then (d) ->
        episodes = for item in $(d.data).find(".videoplaylist-inner .videoplaylist-item")          
          data    = $(item).data().videoplaylistData
          episode = 
            name: data.title
            image: SERVER+data.thumbnailUrl
            runtime: data.duration
            smilUrl: data.releaseUrl
        deferred.resolve episodes
      deferred.promise
    videos: (url) ->
      deferred = $q.defer()
      $http.get(url).then (d) ->
        videos  = []
        data    = d.data.replace(/video/g, 'replacedvideo')
        for _switch, index in $(data).find("switch")
          if index == 0
            for _video in $(_switch).find("replacedvideo")
              srcRe     = /src=\"(.+).mp4\"/
              widthRe   = /width=\"(\d+)\"/
              heightRe  = /height=\"(\d+)\"/
              video     = $(_video)[0].outerHTML
              src       = srcRe.exec(video)[1]
              width     = widthRe.exec(video)[1]
              height    = heightRe.exec(video)[1]
              videos.push {src: src, width: width, height: height}        
        deferred.resolve videos
      deferred.promise
  service
]