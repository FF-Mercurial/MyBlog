require! {
    nodemailer
    './config'
}

user = config.mailUser
pass = config.mailPass
host = config.mailHost

transport = nodemailer.createTransport 'SMTP',
    host: host
    auth:
        user: user
        pass: pass

!function send addr, subject, html
    options =
        from: user
        to: addr
        subject: subject
        html: html

    !function _send
        console.log "mailing to #{addr}.."
        transport.sendMail options, cb
    
    !function cb err, res
        if err
            console.log err
            console.log 'retry.'
            _send!
        else
            console.log "mailed to #{addr}."
            console.log res.message
            transport.close!

    _send!

module.exports =
    send: send
