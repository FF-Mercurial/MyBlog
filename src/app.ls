require! {
    express
    path
    'cookie-parser': cookieParser
    'body-parser': bodyParser
    './routes/routes': routes
}

app = express!

app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'

app.use bodyParser.json!
app.use bodyParser.urlencoded extended: false
app.use cookieParser!
app.use express.static(path.join __dirname, 'public')

app.use '/', routes

app.use (req, res, next)!->
    err = new Error 'Not Found'
    err.status = 404
    nexterr

if app.get('env') == 'development'
    app.use (err, req, res, next)!->
        res.status err.status or 500
        res.render 'error',
            message: err.message
            error: err

app.use (err, req, res, next)!->
    res.status err.status or 500
    res.render 'error',
        message: err.message,
        error: {}

module.exports = app;
