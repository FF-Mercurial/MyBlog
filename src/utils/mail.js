// Generated by LiveScript 1.3.1
(function(){
  var nodemailer, user, pass, transport, options;
  nodemailer = require('nodemailer');
  user = 'ff_mercurial@163.com';
  pass = 'hlpwtsapoukpwfim';
  transport = nodemailer.createTransport('SMTP', {
    host: 'smtp.163.com',
    auth: {
      user: user,
      pass: pass
    }
  });
  options = {
    from: user,
    to: '1362832680@qq.com',
    subject: 'test',
    html: '<p>hello</p>'
  };
  function send(){
    transport.sendMail(options, cb);
  }
  function cb(err, res){
    if (err) {
      console.log(err);
      console.log('retry..');
      send();
    } else {
      console.log(res);
      transport.close();
    }
  }
  send();
  console.log('sending..');
}).call(this);
