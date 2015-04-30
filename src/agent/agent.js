// Generated by LiveScript 1.3.1
(function(){
  "use strict";
  var fs, request, async, post, argv, option, files, jsonStr, e, config, key, server;
  fs = require('fs');
  request = require('request');
  async = require('async');
  post = require('./post');
  argv = process.argv;
  option = argv[2];
  files = argv.slice(3);
  try {
    jsonStr = fs.readFileSync('config.json');
  } catch (e$) {
    e = e$;
    exit('config.json not found.');
  }
  try {
    config = JSON.parse(jsonStr);
  } catch (e$) {
    e = e$;
    exit('bad config.json.');
  }
  key = config.key;
  server = config.server;
  if (!key) {
    exit('no key.');
  }
  if (!server) {
    exit('no server.');
  }
  switch (option) {
  case 'fetch':
    fetch();
    break;
  case 'push':
    push();
    break;
  default:
    exit('nothing done.');
  }
  function push(){
    var posts, tasks;
    posts = [];
    tasks = [];
    if (files.length === 0) {
      exit('no posts to push.');
    }
    files.forEach(function(file){
      tasks.push(function(cb){
        fs.readFile(file, {
          encoding: 'utf-8'
        }, function(err, fileContent){
          var postObject;
          if (err) {
            cb(err);
          } else {
            postObject = post.decode(fileContent);
            posts.push(postObject);
            cb();
          }
        });
      });
    });
    async.parallel(tasks, function(err){
      if (err) {
        exit(err);
      } else {
        request({
          url: server + '/s-push-posts',
          method: 'POST',
          body: {
            key: key,
            posts: posts
          },
          json: true
        }, function(err, res, body){
          if (err) {
            exit(err);
          } else {
            if (res.statusCode === 200) {
              ok();
            } else {
              exit('opppppps!');
            }
          }
        });
      }
    });
  }
  function fetch(){
    request({
      url: server + '/s-fetch-posts',
      method: 'POST',
      body: {
        key: key
      },
      json: true
    }, function(err, res, body){
      var posts, tasks;
      if (err) {
        exit(err);
      } else {
        posts = body;
        tasks = [];
        posts.forEach(function(postObject){
          tasks.push(function(cb){
            var postStr;
            postStr = post.encode(postObject);
            fs.writeFile(postObject.title + '.md', postStr, {
              encoding: 'utf-8'
            }, function(err){
              cb(err);
            });
          });
        });
        async.parallel(tasks, function(err){
          if (err) {
            exit(err);
          } else {
            ok();
          }
        });
      }
    });
  }
  function log(msg){
    console.log(msg);
  }
  function exit(msg){
    log(msg);
    process.exit(1);
  }
  function ok(){
    exit('ok.');
  }
}).call(this);