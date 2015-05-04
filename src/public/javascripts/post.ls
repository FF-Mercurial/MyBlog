window.on 'load', !->
    $ '#comment-form' .on 'submit', (evt)!->
        evt.preventDefault!
        submitComment!
    $ '#comment-list' .on 'click', (evt)!->
        evt.preventDefault!
        setReplying evt.target.getAttribute 'href'

!function setReplying floor
    commentForm = $ '#comment-form'
    commentForm.replying.value = floor
    commentForm.comment.setAttribute 'placeholder', "replying ##{floor}:"
    location.hash = ''
    location.hash = '#comment-form'

!function submitComment
    inputs = $ '#comment-form' .elements
    id = inputs.id.value
    name = inputs.name.value
    email = inputs.email.value
    replying = parseInt inputs.replying.value
    comment = inputs.comment.value
    request.POST '/s-comment', {
        id: id
        name: name
        email: email
        replying: replying
        comment: comment
    }, (res)!-> if res.msg == 'ok' then location.reload! else alert res.msg
