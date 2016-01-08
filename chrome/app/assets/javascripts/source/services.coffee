app = angular.module "travelChannel.services", []

app.service "Episodes", [ "$http", "$q", "SERVER", "EPISODES", ($http, $q, SERVER, EPISODES) ->
  service =
    videos: (link) ->
      deferred  = $q.defer()      
      $http.get(SERVER+link).then (linkData) ->
        url       = $(linkData.data).find("meta[itemprop='url']")[0].content
        deferred2 = $q.defer()        
        $http.get(url).then (SMILData) =>
          videos  = []
          data    = SMILData.data.replace(/video/g, 'replacedvideo')
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
          deferred2.resolve videos        
        deferred.resolve deferred2.promise
      deferred.promise

    index: ->
      deferred = $q.defer()
      $http.get(SERVER+EPISODES).then (d) ->
        programs = for _section in $(d.data).find(".fullEpisode section.jukebox-wrapper")
          section = $(_section)
          program =
            title:    section.find("h2.jukebox-header-title").text()
            episodes: []
          for _item in section.find(".jukebox-inner .jukebox-item")            
            item    = $(_item)
            link    = item.find(".jukebox-item-title a").attr("href")
            episode = 
              title:    item.find(".jukebox-item-title a").text()
              runtime:  item.find(".jukebox-item-title small").text()
              link:     link
              image:    item.find(".jukebox-item-media a.icon img").attr("src")
            program.episodes.push episode
          program
        deferred.resolve programs
      deferred.promise
  service
]