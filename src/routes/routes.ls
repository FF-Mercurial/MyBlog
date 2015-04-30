require! {
    express
    marked
    '../utils/config'
    '../utils/db'
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
        else
            if post
                post.content = md post.content
                res.render 'post', post: post
            else
                next!

router.post '/s-push-posts', checkKey, (req, res)!->
    posts = req.body.posts
    db.pushPosts posts, (err)!->
        if err
            e5 res
        else
            res.end!

router.post '/s-fetch-posts', checkKey, (req, res)!->
    db.getPosts null, (err, posts)!->
        if err
            e5 res
        else
            res.json posts

!function checkKey req, res, next
    key = req.body.key
    if key != config.key
        e4 res
    else
        next!

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
            posts.forEach (post)!->
                post.summary = md post.summary
            db.getTags (err, tags)!->
                if err
                    log res, JSON.stringify(err)
                else
                    res.render 'posts',
                        tags: tags
                        posts: posts

!function e status, res
    if status == 4
        res.status 400
    else if status == 5
        res.status 500
    res.end!

!function e4 res
    e 4, res

!function e5 res
    e 5, res

!function log res, msg
    res.render 'log', msg: msg

function md src
    marked src

module.exports = router;
