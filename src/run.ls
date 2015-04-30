require! {
    http
    debug
    './app': app
}

port = parseInt(process.argv[1]) or 80
app.set 'port', port

server = http.createServer app

server.listen port
server.on 'error', onError
server.on 'listening', onListening

!function onError err
    if err.syscall != 'listen'
        throw err

    switch err.code
        case 'EACCES'
            console.error 'requires elevated privileges'
            process.exit 1
        case 'EADDRINUSE'
            console.error 'port already in use'
            process.exit 1
        default
            throw err

!function onListening
    console.log 'listening..'
    debug!!
    _debug = debug 'MyBlog'
    _debug 'listening..'
