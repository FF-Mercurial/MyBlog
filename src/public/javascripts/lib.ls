exports = window

Object.prototype.on = (evt, cb)!->
    this.addEventListener evt, cb

exports.$ = (selector)->
    if selector[0] == '#'
        id = selector.substr 1
        return document.getElementById id
    else
        className = selector.substr 1
        return document.getElementsByClassName className

exports.request = do ->
    function request method, url, data, cb
        req = new XMLHttpRequest
        req.open method, url
        req.responseType = 'json'
        req.onload = !->
            res = this.response
            cb res
        req.setRequestHeader 'Content-type', 'application/json'
        req.send JSON.stringify data

    !function GET url, cb
        request 'GET', url, null, cb
    
    !function POST url, data, cb
        request 'POST', url, data, cb

    return {
        GET: GET
        POST: POST
    }
