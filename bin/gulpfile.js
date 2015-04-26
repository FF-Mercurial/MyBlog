(function(){
  var gulp, path, async, cp, ls, less, restart;
  gulp = require('gulp');
  path = require('path');
  async = require('async');
  cp = require('child_process');
  ls = require('gulp-livescript');
  less = require('gulp-less');
  restart = function(){
    var p;
    function restart(cb){
      if (p) {
        p.kill();
        log('restarted.');
      }
      p = cp.spawn('node', ['../bin/run.js'], {
        cwd: '../bin'
      });
      p.stdout.on('data', function(chunk){
        process.stdout.write(chunk.toString());
      });
      p.stderr.on('data', function(chunk){
        process.stderr.write(chunk.toString());
      });
      return cb();
    }
    return restart;
  }();
  gulp.task('default', function(){
    async.series([rebuild, restart, watch], function(err){
      if (err) {
        log(err);
      }
    });
  });
  function compile(extension, compiler, cb){
    gulp.src('**/*.' + extension).pipe(compiler).pipe(gulp.dest('../bin')).on('end', cb);
  }
  function compileLess(cb){
    compile('less', less(), cb);
  }
  function compileLs(cb){
    compile('ls', ls(), cb);
  }
  function copyJade(cb){
    cp.exec('cp -r views ../bin', cb);
  }
  function build(cb){
    async.parallel([compileLess, compileLs, copyJade], function(){
      log('builded.');
      cb();
    });
  }
  function clear(cb){
    cp.exec('rm -r ../bin/*', function(){
      log('cleared');
      cb();
    });
  }
  function rebuild(cb){
    async.series([clear, build], cb);
  }
  function watch(cb){
    var _paths, paths;
    _paths = ['public/**/*.less', 'public/**/*.ls'];
    paths = ['routes/**/*.ls', 'app.ls', 'run.ls'];
    _paths.forEach(function(path){
      gulp.watch(path, function(){
        rebuild();
      });
    });
    paths.forEach(function(path){
      gulp.watch(path, function(){
        async.series([rebuild, restart]);
      });
    });
    log('watching..');
    cb();
  }
  function log(msg){
    console.log(msg + ' ' + (new Date).toString());
  }
}).call(this);
