require! {
    express
    marked
    './utils/mail'
    './utils/config'
    './utils/db'
    './utils/mail'
}

router = express.Router!

router.get '/', (req, res)!->
    postsHandler page: 0, req, res

router.get '/posts', (req, res)!->
    postsHandler page: 0, req, res

router.get '/posts/:page', (req, res)!->
    page = req.params.page
    postsHandler page: page, req, res

router.get '/posts/:page/:tag', (req, res)!->
    page = req.params.page
    tag = req.params.tag
    postsHandler {
        page: page
        tag: tag
    }, req, res

router.get '/post/:id', (req, res, next)!->
    id = req.params.id
    db.getPost id, (err, post)!->
        if err
            e5 res
        else if post
            post.content = md post.content
            res.render 'post/post', post: post
        else
            next!

router.post '/s-push-posts', checkKey, (req, res)!->
    posts = req.body.posts
    date = new Date
    db.pushPosts posts, date, (err)!-> if err then e5 res else ok res

router.post '/s-fetch-posts', (req, res)!->
    db.getPosts null, (err, posts)!-> if err then e5 res else res.json posts

router.post '/s-comment', (req, res)!->
    id = req.body.id
    name = req.body.name
    email = req.body.email
    replying = req.body.replying
    comment = req.body.comment
    date = new Date
    db.comment id, name, email, replying, comment, date, (err, email)!->
        if err 
            e5 res
        else
            ok res
            if email
                subject = 'someone replied you on FF_Mercurial\'s Blog'
                html = "<a href='http://#{config.host}/post/#{id}'>see here</a>"
                mail.send email, subject, html

router.get '/s-mail/:addr/:subject/:html', (req, res)!->
    addr = req.params.addr
    subject = req.params.subject
    html = req.params.html
    mail.send addr, subject, html
    ok res

!function checkKey req, res, next
    key = req.body.key
    if key != config.key then e4 res else next!

!function postsHandler query, req, res
    postsPerPage = config.postsPerPage
    page = query.page
    tag = query.tag
    db.getPosts {
        from: postsPerPage * page
        to: postsPerPage * (page + 1)
        tag: tag
    }, (err, posts)!->
        if err
            log res, JSON.stringify(err)
        else
            posts.forEach (post)!-> post.summary = md post.summary
            db.getTags (err, tags)!->
                if err
                    log res, JSON.stringify(err)
                else
                    res.render 'posts/posts',
                        tags: tags
                        posts: posts

!function e status, res
    if status == 4
        res.status 400
    else if status == 5
        res.status 500
    res.end!

!function e4 res
    res.json msg: '400'

!function e5 res
    res.json msg: '500'

!function ok res
    res.json msg: 'ok'

!function log res, msg
    res.render 'log/log', msg: msg

function targetBlank src
    src.replace /<a /g, '$&target="_blank" '

function md src
    targetBlank marked src

module.exports = router;
