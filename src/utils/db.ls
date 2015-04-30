require! {
    mongodb
    async
    './config'
}

url = config.mongoUrl
_db = null

!function connect _cb, cb
    if _db
        cb _db
    else
        mongodb.MongoClient.connect url, (err, db)!->
            if err
                _cb err
            else
                _db := db
                cb db

!function pushPosts posts, cb
    connect cb, (db)!->
        Post = db.collection 'posts'
        tasks = []
        posts.forEach (post)!->
            title = post.title
            tasks.push (cb)!->
                Post.find title: title .toArray (err, docs)!->
                    if err
                        cb err
                    else if docs[0]
                        Post.update {
                            _id: mongodb.ObjectId(docs[0]._id)
                        }, {
                            $set: post
                        }, (err, res)!->
                            cb err
                    else
                        post.comments = []
                        post.pubDate = new Date!
                        Post.insert post, (err)!-> cb err
        async.series tasks, (err)!-> cb err
            
!function getPosts query, cb
    connect cb, (db)!->
        Post = db.collection 'posts'
        _query = {}
        if query.tag
            _query.tags = $in: [query.tag]
        pipeline = Post.find _query .sort pubDate: -1
        if query.range
            pipeline.skip query.range.from .limit query.range.to
        pipeline.toArray (err, posts)!->
            if (err)
                cb err
            else
                cb null, posts

!function getTags cb
    connect cb, (db)!->
        Post = db.collection 'posts'
        Post.find {} .toArray (err, posts)!->
            if err
                cb err
            else
                tags = {}
                posts.forEach (post)!->
                    post.tags.forEach (name)!->
                        if not tags[name]
                            tags[name] = 1
                        else
                            tags[name]++
                cb null, tags

!function getPost id, cb
    connect cb, (db)!->
        Post = db.collection 'posts'
        Post.find _id: mongodb.ObjectId(id), .toArray (err, posts)!->
            if err
                cb err
            else
                post = posts[0]
                cb null, post

module.exports =
    getPost: getPost
    getPosts: getPosts
    getTags: getTags
    pushPosts: pushPosts
