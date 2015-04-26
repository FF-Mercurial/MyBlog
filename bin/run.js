(function(){
  var http, app, port, server;
  http = require('http');
  app = require('./app');
  port = parseInt(process.argv[1]) || 3000;
  app.set('port', port);
  server = http.createServer(app);
  server.listen(port);
  server.on('error', onError);
  server.on('listening', onListening);
  function onError(err){
    return console.log(err);
  }
  function onListening(){
    return console.log('listening..');
  }
}).call(this);
