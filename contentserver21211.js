/*
 * Module dependencies & Server Setup
 */
var express = require('express'),
    stylus = require('stylus'),
    nib = require('nib'),
    cookieParser= require('cookie-parser'),
    bodyParser= require('body-parser'),
    session = require('express-session')

/*
 * Server setup
 */
var app = express()


app.set('views', __dirname + '/views')
app.set('view engine', 'jade')

logger = require('morgan');
app.use(logger('dev'));

app.use(session({
    secret: 'anything'
}));
app.use(bodyParser.urlencoded());
app.use(bodyParser.json());
app.use(cookieParser());
app.use(stylus.middleware({
    src: __dirname + '/public',
    compile: function(str, path) {
    return stylus(str).set('filename', path).use(nib());
    }
}));

if (app.get('env') === 'development') {
    app.locals.pretty = true; //Format html code when in dev
}

app.set('port', (process.env.PORT || 21211));
app.listen(app.get('port'), function() {
  console.log('Node app is running on port', app.get('port'));
});

//fixes server crashed due to memleaks
function myMiddleware (req, res, next) { 
   if (req.method === 'GET') { 
     global.gc();
   }

   // keep executing the router middleware
   next()
}

app.use(myMiddleware);

//doing serious CORS stuff
app.all('*', function(req, res, next) {

  res.setHeader('Access-Control-Allow-Origin', '*');
  // res.setHeader('Access-Control-Allow-Origin', req.headers.origin);
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE, CONNECT');
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With, X-HTTP-Method-Override, Content-Type, Accept, Content-Length');
  res.setHeader('Access-Control-Allow-Credentials', true);
  res.setHeader('Access-Control-Max-Age', '86400'); // 24 hours
  res.setHeader('Access-Control-Expose-Headers', 'Content-Length');

  next();
});

app.use(express.static(__dirname + '/public'))