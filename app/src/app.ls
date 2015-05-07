require! {
    express
    path
    fs
    'morgan': logger
    'cookie-parser': cookieParser
    'body-parser': bodyParser
    './routes/routes'
}

app = express!

app.set 'env', 'development'
# app.set 'env', 'release'

app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'

app.use logger 'dev'
app.use bodyParser.json!
app.use bodyParser.urlencoded extended: false
app.use cookieParser!
app.use '/public', express.static(path.join __dirname, 'public')

app.use routes

app.use (req, res, next)!->
    err = new Error 'Not Found'
    err.status = 404
    next err

if app.get('env') == 'development'
    app.use (err, req, res, next)!->
        console.log err
        res.status(err.status or 500)
        res.render 'error',
            message: err.message
            error: err

app.use (err, req, res, next)!->
    res.status(err.status or 500)
    res.render 'error',
        message: err.message
        error: {}

module.exports = app;
