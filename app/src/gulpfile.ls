require! {
    async
    fs
    child_process: cp
    gulp
    'gulp-livescript': ls
    'gulp-less': less
    eventemitter2
}
EventEmitter2 = eventemitter2.EventEmitter2

dft = do ->
    log = (msg, tab)!->
        _msg = msg
        tab = tab or 0
        for i from 0 til tab
            _msg = '    ' + _msg
        console.log _msg
    clear = (cb)!->
        cp.exec 'rm ../bin -r', !->
            log 'cleared.', 0
            cb!
    build = do ->
        compileAll = do ->
            _compile = (srcPath, destPath, compiler, cb)!->
                gulp.src srcPath
                    .pipe compiler
                    .pipe gulp.dest destPath
                    .on 'end' cb
            compileLs = do ->
                compileServer = (cb)!->
                    async.parallel [
                        (cb)!-> _compile 'app.ls', '../bin', ls!, cb
                        (cb)!-> _compile 'run.ls', '../bin', ls!, cb
                        (cb)!-> _compile 'routes/**/*.ls', '../bin/routes', ls!, cb
                    ], cb
                compilePublic = (cb)!->
                    _compile 'views/**/*.ls', '../bin/public', ls!, cb
                return (cb)!->
                    async.parallel [
                        compileServer
                        compilePublic
                    ], cb
            compileLess = (cb)!->
                _compile 'views/**/*.less' , '../bin/public', less!, cb
            return (cb)!->
                async.parallel [
                    compileLs
                    compileLess
                ], cb
        copyAll = do !->
            copyJade = (cb)!->
                gulp.src 'views/**/*.jade'
                    .pipe gulp.dest '../bin/views'
                    .on 'end' cb
            copyAssets = (cb)!->
                gulp.src '../assets/**/*'
                    .pipe gulp.dest '../bin/public'
                    .on 'end' cb
            return (cb)!->
                async.parallel [
                    copyJade
                    copyAssets
                ], cb
        return (cb)!->
            async.parallel [
                compileAll
                copyAll
            ], (err)!->
                log 'builded.', 0
                cb err
    start = do ->
        serverProcess = null
        return (cb)!->
            serverProcess and serverProcess.kill!
            serverProcess := cp.spawn 'node', ['../bin/run.js'], cwd: '../bin'
            serverProcess.stdout.on 'data', (chunk)!->
                console.log chunk.toString!
            serverProcess.stderr.on 'data', (chunk)!->
                console.error chunk.toString!
            log 'started.', 0
            cb!
    watch = do ->
        eventBus = new EventEmitter2
        eventBus.on 'restart', (cb)!->
            async.series [
                clear
                build
                start
            ], cb
        eventBus.on 'rebuild', (cb)!->
            async.series [
                clear
                build
            ], cb
        watchServer = !->
            paths = ['app.ls', 'run.ls', 'config.json', 'router/*.ls']
            paths.forEach (path)!->
                gulp.watch path, !->
                    eventBus.emit 'restart'
        watchPublic = !->
            paths = ['views/**/*.less', 'views/**/*.less']
            paths.forEach (path)!->
                gulp.watch path, !->
                    eventBus.emit 'rebuild'
        return (cb)!->
            watchServer!
            watchPublic!
            log 'watching..', 0
            cb!
    return (cb)!->
        async.series [
            clear
            build
            start
            watch
        ], cb

gulp.task 'default', dft
