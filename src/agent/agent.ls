"use strict"

require! {
    fs
    request
    async
    './post'
}

argv = process.argv
option = argv[2]
files = argv.slice 3

try
    jsonStr = fs.readFileSync 'config.json'
catch
    exit 'config.json not found.'

try
    config = JSON.parse jsonStr
catch
    exit 'bad config.json.'

key = config.key
server = config.server
if not key
    exit 'no key.'
if not server
    exit 'no server.'

switch option
    case 'fetch'
        fetch!
    case 'push'
        push!
    default
        exit 'nothing done.'

!function push
    posts = []
    tasks = []
    if files.length == 0
        exit 'no posts to push.'
    files.forEach (file)!->
        tasks.push (cb)!->
            fs.readFile file, encoding: 'utf-8', (err, fileContent)!->
                if err
                    cb err
                else
                    postObject = post.decode fileContent
                    posts.push postObject
                    cb!

    async.parallel tasks, (err)!->
        if err
            exit err
        else
            request {
                url: server + '/s-push-posts'
                method: 'POST'
                body:
                    key: key
                    posts: posts
                json: true
            }, (err, res, body)!->
                if err
                    exit err
                else
                    if res.statusCode == 200
                        ok!
                    else
                        exit 'opppppps!'
    
!function fetch
    request {
        url: server + '/s-fetch-posts'
        method: 'POST'
        body:
            key: key
        json: true
    }, (err, res, body)!->
        if err
            exit err
        else
            posts = body
            tasks = []
            posts.forEach (postObject)!->
                tasks.push (cb)!->
                    postStr = post.encode postObject
                    fs.writeFile postObject.title + '.md', postStr, encoding: 'utf-8', (err)!-> cb err
            async.parallel tasks, (err)!->
                if err
                    exit err
                else
                    ok!

!function log msg
    console.log msg

!function exit msg
    log msg
    process.exit 1

!function ok
    exit 'ok.'
