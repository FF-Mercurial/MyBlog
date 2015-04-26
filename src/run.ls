require! {
    http
    './app': app
}

port = parseInt(process.argv[1]) or 3000
app.set 'port', port

server = http.createServer app

server.listen port
server.on 'error', onError
server.on 'listening', onListening

function onError err
    console.log err

function onListening
    console.log 'listening..'
