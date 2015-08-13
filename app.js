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

app.set('port', (process.env.PORT || 21210));
app.listen(app.get('port'), function() {
  console.log('Node app is running on port', app.get('port'));
});

//read serverlist on startup and create logfile
var fs = require('fs');

var d= new Date();
d.setMonth(d.getMonth()+1);
var dateString= d.getDate() + "_" + d.getMonth() + "_Time_" + d.getHours() + "_" + d.getMinutes();
var logStream = fs.createWriteStream('./log/'+dateString + '_log.csv');
logStream.write("\"sep= \"\r\n"); //Separator for csv
var path = './serverlist';
var serverArray = fs.readFileSync(path).toString().split('\r\n');

//fixes server crashed due to memleaks
function myMiddleware (req, res, next) { 
   if (req.method === 'GET') { 
     global.gc();
   }

   // keep executing the router middleware
   next()
}

app.use(myMiddleware);
app.use(express.static(__dirname + '/public'))


var users=[];
/* Redirects
*
*/

    app.post('/logthis',function(req,res){
      var loggedString=req.body.loggedstring;
      console.log("Log: "+loggedString);

      var sessionID=req.sessionID;
      var userNumber=users.indexOf(sessionID)
      if(userNumber==-1){
        	users.push(sessionID);
        	userNumber=users.length-1;        	
        	req.session.userNO=userNumber;
      }

      console.log(loggedString+" UserID: "+userNumber+ " "+req.session.userNO+ '\r\n');
      res.end("done");
    });

	app.get('/', function(req, res) {
	    var sessionID=req.sessionID;
        var userNumber=users.indexOf(sessionID)
        if(userNumber==-1){
        	users.push(sessionID);
        	userNumber=users.length-1;        	
        	req.session.userNO=userNumber;
        }
	    res.render('index', {
	        title: 'Home',
	        user: req.user
	    })
	})
	app.get('/serverlist', function(req, res) {
		res.json({
            availableServers: serverArray
        });
	})	
	app.get('/srcSet', function(req, res) {
	    res.render('srcSet', {
	        title: 'Source Set Algo',
	        user: req.user
	    })
	})
	app.get('/srcSet2', function(req, res) {
	    res.render('srcSet2', {
	        title: 'Original SRCSET',
	        user: req.user
	    })
	})
	app.get('/about', function(req, res) {
	    res.render('about', {
	        title: 'About',
	        user: req.user
	    })
	})
	app.get('/contact', function(req, res) {
	    res.render('contact', {
	        title: 'Contact',
	        user: req.user
	    })
	})


