// Generated by CoffeeScript 1.9.3
(function() {
  var app;

  app = angular.module("travelChannel.services", []);

  app.service("Episodes", [
    "$http", "$q", "SERVER", "EPISODES", function($http, $q, SERVER, EPISODES) {
      var service;
      service = {
        videos: function(link) {
          var deferred;
          deferred = $q.defer();
          $http.get(SERVER + link).then(function(linkData) {
            var deferred2, url;
            url = $(linkData.data).find("meta[itemprop='url']")[0].content;
            deferred2 = $q.defer();
            $http.get(url).then((function(_this) {
              return function(SMILData) {
                var _switch, _video, data, height, heightRe, i, index, j, len, len1, ref, ref1, src, srcRe, video, videos, width, widthRe;
                videos = [];
                data = SMILData.data.replace(/video/g, 'replacedvideo');
                ref = $(data).find("switch");
                for (index = i = 0, len = ref.length; i < len; index = ++i) {
                  _switch = ref[index];
                  if (index === 0) {
                    ref1 = $(_switch).find("replacedvideo");
                    for (j = 0, len1 = ref1.length; j < len1; j++) {
                      _video = ref1[j];
                      srcRe = /src=\"(.+).mp4\"/;
                      widthRe = /width=\"(\d+)\"/;
                      heightRe = /height=\"(\d+)\"/;
                      video = $(_video)[0].outerHTML;
                      src = srcRe.exec(video)[1];
                      width = widthRe.exec(video)[1];
                      height = heightRe.exec(video)[1];
                      videos.push({
                        src: src,
                        width: width,
                        height: height
                      });
                    }
                  }
                }
                return deferred2.resolve(videos);
              };
            })(this));
            return deferred.resolve(deferred2.promise);
          });
          return deferred.promise;
        },
        index: function() {
          var deferred;
          deferred = $q.defer();
          $http.get(SERVER + EPISODES).then(function(d) {
            var _item, _section, episode, item, link, program, programs, section;
            programs = (function() {
              var i, j, len, len1, ref, ref1, results;
              ref = $(d.data).find(".fullEpisode section.jukebox-wrapper");
              results = [];
              for (i = 0, len = ref.length; i < len; i++) {
                _section = ref[i];
                section = $(_section);
                program = {
                  title: section.find("h2.jukebox-header-title").text(),
                  episodes: []
                };
                ref1 = section.find(".jukebox-inner .jukebox-item");
                for (j = 0, len1 = ref1.length; j < len1; j++) {
                  _item = ref1[j];
                  item = $(_item);
                  link = item.find(".jukebox-item-title a").attr("href");
                  episode = {
                    title: item.find(".jukebox-item-title a").text(),
                    runtime: item.find(".jukebox-item-title small").text(),
                    link: link,
                    image: item.find(".jukebox-item-media a.icon img").attr("src")
                  };
                  program.episodes.push(episode);
                }
                results.push(program);
              }
              return results;
            })();
            return deferred.resolve(programs);
          });
          return deferred.promise;
        }
      };
      return service;
    }
  ]);

}).call(this);
