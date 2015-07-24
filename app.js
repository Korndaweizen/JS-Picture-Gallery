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
app.use(express.logger('dev'))
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
app.use(express.static(__dirname + '/public'))





	
if (app.get('env') === 'development') {
    app.locals.pretty = true; //Format html code when in dev
}

app.set('port', (process.env.PORT || 21210));
app.listen(app.get('port'), function() {
  console.log('Node app is running on port', app.get('port'));
});

//app.listen(3000)






/* Redirects
*
*/
	app.get('/', function(req, res) {
	    res.render('index', {
	        title: 'Home',
	        user: req.user
	    })
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


