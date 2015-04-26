(function(){
  var express, path, cookieParser, bodyParser, routes, app;
  express = require('express');
  path = require('path');
  cookieParser = require('cookie-parser');
  bodyParser = require('body-parser');
  routes = require('./routes/index');
  app = express();
  app.set('views', path.join(__dirname, 'views'));
  app.set('view engine', 'jade');
  app.use(bodyParser.json());
  app.use(bodyParser.urlencoded({
    extended: false
  }));
  app.use(cookieParser());
  app.use(express['static'](path.join(__dirname, 'public')));
  app.use('/', routes);
  app.use(function(req, res, next){
    var err;
    err = new Error('Not Found');
    err.status = 404;
    nexterr;
  });
  if (app.get('env') === 'development') {
    app.use(function(err, req, res, next){
      res.status(err.status) || 500;
      res.render('error', {
        message: err.message,
        error: err
      });
    });
  }
  app.use(function(err, req, res, next){
    res.status(err.status) || 500;
    res.render('error', {
      message: err.message,
      error: {}
    });
  });
  module.exports = app;
}).call(this);
