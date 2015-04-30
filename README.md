# MyBlog

## pages
- /posts/:page
    - tags
        - name: String
        - postsCount: Number
    - posts
        - id: String
        - title: String
        - summary: String
        - pubDate: Date
        - commentsCount: Number
- /post/:id
    - title: String
    - tags:
        - name: String
    - content: String
    - pubDate: Date
    - comments:
        - floor: Number
        - name: String
        - email: String
        - replying: Number

## web interface
- /s-push-posts
    - ->
        - key
        - posts
            - title
            - tags
            - summary
            - content

- /s-fetch-posts
    - ->
        - key
    - <-
        - posts: 
            - title
            - tags
            - summary
            - content

- /s-comment
    - ->
        - name
        - email
        - replying
        - content

## model
- post
    - title: String
    - tags:
        - name: String
    - summary: String
    - content: String
    - pubDate: Date
    - comments:
        - floor: Number
        - name: String
        - email: String
        - content: String
        - replying: Number
