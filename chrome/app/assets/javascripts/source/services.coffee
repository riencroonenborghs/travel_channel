app = angular.module "travelChannel.services", []

app.service "Channel", [ "$http", "$q", "SERVER", "EPISODES", "$parse", ($http, $q, SERVER, EPISODES, $parse) ->
  service:
    programs: ->
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
    episodes: (program) ->
      deferred = $q.defer()
      $http.get(SERVER+program.url).then (d) => 
        playlistItems = $(d.data).find(".videoplaylist-item")
        episodes      = for playlistItem in playlistItems
          data    = $(playlistItem).data().videoplaylistData
          episode = 
            title: data.title
            description: data.description
            smil: data.releaseUrl
            image: SERVER+data.thumbnailUrl
            duration: data.duration
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
              video = $(_video)[0].outerHTML
              src = srcRe.exec(video)[1]
              width = widthRe.exec(video)[1]
              height = heightRe.exec(video)[1]
              list.push {src: src, width: width, height: height}
        deferred.resolve list
      deferred.promise
]