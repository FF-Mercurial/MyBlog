require! {
    mongodb
    async
    './config'
}

url = config.mongoUrl
_db = null

function union a, b
    res = {}
    for key, value of a then res[key] = a[key]
    for key, value of b then res[key] = b[key]
    return res

!function connect _cb, cb
    if _db
        cb _db
    else
        mongodb.MongoClient.connect url, (err, db)!-> if err then _cb err else cb(_db := db)

!function pushPosts posts, date, cb
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
                            $set: union post, updateDate: date
                        }, (err, res)!-> cb err
                    else
                        post.comments = []
                        post.pubDate = date
                        post.updateDate = date
                        Post.insert post, (err)!-> cb err
        async.series tasks, (err)!-> cb err
            
!function getPosts query, cb
    connect cb, (db)!->
        Post = db.collection 'posts'
        _query = {}
        query and query.tag and _query.tags = $in: [query.tag]
        pipeline = Post.find _query .sort pubDate: -1
        query and query.range and pipeline.skip query.range.from .limit query.range.to
        pipeline.toArray (err, posts)!-> if err then cb err else cb null, posts

!function getTags cb
    connect cb, (db)!->
        Post = db.collection 'posts'
        Post.find {} .toArray (err, posts)!->
            if err
                cb err
            else
                tags = {}
                posts.forEach (post)!-> post.tags.forEach (name)!-> if tags[name] then tags[name]++ else tags[name] = 1
                cb null, tags

!function getPost id, cb
    connect cb, (db)!->
        Post = db.collection 'posts'
        Post.find _id: mongodb.ObjectId(id), .toArray (err, posts)!-> cb err, posts[0]

!function comment id, name, email, replying, content, date, cb
    connect cb, (db)!->
        Post = db.collection 'posts'
        Post.update _id: mongodb.ObjectId(id), {
            $push:
                comments:
                    name: name
                    email: email
                    replying: replying
                    content: content
                    date: date
        }, (err)!->
            if err
                cb err
            else
                Post.find _id: mongodb.ObjectId(id) .toArray (err, posts)!->
                    if err
                        cb err
                    else
                        post = posts[0]
                        comment = post and post.comments[replying]
                        replyingEmail = comment and comment.email
                        cb null, replyingEmail

module.exports =
    getPost: getPost
    getPosts: getPosts
    getTags: getTags
    pushPosts: pushPosts
    comment: comment
