// Generated by CoffeeScript 1.9.3
(function() {
  var app;

  app = angular.module("travelChannel.services", []);

  app.service("TravelChannel", [
    "$http", "$q", "SERVER", "EPISODES", function($http, $q, SERVER, EPISODES) {
      var service;
      service = {
        programs: function() {
          var deferred;
          deferred = $q.defer();
          $http.get(SERVER + EPISODES).then(function(d) {
            var i, item, len, program, programs, ref;
            programs = [];
            ref = $(d.data).find(".fullEpisode");
            for (i = 0, len = ref.length; i < len; i++) {
              item = ref[i];
              program = {
                name: $(item).find(".jukebox-header h2").html(),
                url: $(item).find(".jukebox-header .jukebox-header-moreText").attr("href"),
                image: $(item).find(".jukebox-inner .jukebox-item-media img").attr("src")
              };
              if (program.name) {
                programs.push(program);
              }
            }
            return deferred.resolve(programs);
          });
          return deferred.promise;
        },
        episodes: function(url) {
          var deferred;
          deferred = $q.defer();
          $http.get(SERVER + url).then(function(d) {
            var data, episode, episodes, item;
            episodes = (function() {
              var i, len, ref, results;
              ref = $(d.data).find(".videoplaylist-inner .videoplaylist-item");
              results = [];
              for (i = 0, len = ref.length; i < len; i++) {
                item = ref[i];
                data = $(item).data().videoplaylistData;
                results.push(episode = {
                  name: data.title,
                  image: SERVER + data.thumbnailUrl,
                  runtime: data.duration,
                  smilUrl: data.releaseUrl
                });
              }
              return results;
            })();
            return deferred.resolve(episodes);
          });
          return deferred.promise;
        },
        videos: function(url) {
          var deferred;
          deferred = $q.defer();
          $http.get(url).then(function(d) {
            var _switch, _video, data, height, heightRe, i, index, j, len, len1, ref, ref1, src, srcRe, video, videos, width, widthRe;
            videos = [];
            data = d.data.replace(/video/g, 'replacedvideo');
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
            return deferred.resolve(videos);
          });
          return deferred.promise;
        }
      };
      return service;
    }
  ]);

}).call(this);
