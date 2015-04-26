require! {
    gulp
    path
    async
    'child_process': cp
    'gulp-livescript': ls
    'gulp-less': less
}

restart = do ->
    var p
    function restart cb
        if p
            p.kill!
            log 'restarted.'
        p := cp.spawn 'node', ['../bin/run.js'], cwd: '../bin'
        p.stdout.on 'data', (chunk)!->
            process.stdout.write chunk.toString!
        p.stderr.on 'data', (chunk)!->
            process.stderr.write chunk.toString!
        cb!
    restart

gulp.task 'default', !->
    async.series [
        rebuild
        restart
        watch
    ], (err)!->
        log err if err

!function compile extension, compiler, cb
    gulp.src '**/*.' + extension
        .pipe compiler
        .pipe gulp.dest '../bin'
        .on 'end', cb

!function compileLess cb
    compile 'less', less!, cb

!function compileLs cb
    compile 'ls', ls!, cb

!function copyJade cb
    cp.exec 'cp -r views ../bin', cb

!function build cb
    async.parallel [
        compileLess
        compileLs
        copyJade
    ], !->
        log 'builded.'
        cb!

!function clear cb
    cp.exec 'rm -r ../bin/*', !->
        log 'cleared'
        cb!

!function rebuild cb
    async.series [
        clear
        build
    ], cb

!function watch cb
    _paths = ['public/**/*.less', 'public/**/*.ls']
    paths = ['routes/**/*.ls', 'app.ls', 'run.ls']
    _paths.forEach (path)!-> gulp.watch path, !-> rebuild!
    paths.forEach (path)!-> gulp.watch path, !->
        async.series [
            rebuild
            restart
        ]
    log 'watching..'
    cb!

!function log msg
    console.log msg + ' ' + (new Date).toString!
