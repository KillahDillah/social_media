const express = require('express')
const app = express()
const path = require('path')
const mustacheExpress = require('mustache-express');
const bodyParser = require('body-parser')
const config = require('config')
const hash = require('js-sha512')
const mysql = require('mysql')
const session = require('express-session')
const moment = require('moment')

app.use(bodyParser.urlencoded({extended:false}))
app.use(bodyParser.json())
app.engine('mustache', mustacheExpress())
app.set('views', './views')
app.set('view engine', 'mustache')
app.use(express.static(path.join(__dirname, 'static')))

// before you use this, make sure to update the default.json file in /config
const conn = mysql.createConnection({
  host: config.get('db.host'),
  database: config.get('db.database'),
  user: config.get('db.user'),
  password: config.get('db.password')
})

app.use(express.static(path.join(__dirname, 'static')))
app.use(session({
  secret: "keyboard cat",
  resave: false,
  saveUninitialized: true,
}))

app.get("/", function(req, res, next){
	res.render("login")
})

app.post("/login", function(req,res,next){
	const username = req.body.username
	const password = hash(req.body.password)

	const sql = `
		SELECT * 
		FROM users
		WHERE username = ?
		AND password = ?
	`
	conn.query(sql, [username, password], function(err, results, fields){
  	if (results.length > 0) { // username and password are correct
  		req.session.username = username
  		req.session.userid = results[0].userid
      res.redirect("/" + username + "/homepage")
    } else {
      next("Your shit don't match!")
    }
   })
})

app.post("/signup", function(req,res,next){
	const fname = req.body.firstname
	const lname = req.body.lastname
	const username = req.body.desired_username
	const password = hash(req.body.password)
	const side = req.body.side

	const sql = `
	INSERT INTO users (fname, lname, username, password, side)
	VALUES (?,?,?,?,?)
	`
	conn.query(sql,[fname,lname,username,password,side], function(err,results,fields){
		if (!err) {
			req.session.username = username
  		req.session.userid = results.insertId
			res.redirect("/" + username + "/gab")
		} else {
			next("Username already taken")
		}
	})
})

app.get ('/logout', function(req,res,next){
	req.session.destroy()
	res.redirect("/")
})

app.get("/:username/gab", function(req,res,next){
	res.render("gab", {username:req.session.username, userid:req.session.userid})
})

app.post("/:username/gab", function(req,res,next){
	const gab = req.body.newgab

	const sql = `
		INSERT INTO gabs (gabtext, userid)
		VALUES (?, ?)
	`

	conn.query(sql, [gab, req.session.userid], function(err,results,fields){
		if (!err) {
			res.redirect("/:username/homepage") 
		} else {
			next("Oops. Our fault.")
		}
	})
})


app.get ("/:username/homepage", function(req,res,next){
	const sql = `
	SELECT 
    g.*, u.fname, COUNT(l.id) AS likes
	FROM
    gabs g
		   LEFT OUTER JOIN
	    likes l ON g.gabid = l.gabid
	       INNER JOIN
	    users u ON u.userid = g.userid
	GROUP BY g.gabid
	ORDER BY g.gabid DESC
	LIMIT 10
	`
	conn.query (sql, function(err,results,fields){
	  var cxt = {
	    gabs:results.map(function(item){
	      if (item.likes === 0) {
	        return {
	          gabid:item.gabid,
	          gabtext: item.gabtext,
	          timestamp: moment(item.timestamp).fromNow(),
	          fname:item.fname,
	          likes: "Nobody likes this"
	        }
	      } if (item.likes === 1) {
	        return {
	          gabid:item.gabid,
	          gabtext: item.gabtext,
	          timestamp: moment(item.timestamp).fromNow(),
	          fname:item.fname,
	          likes: "1 like, that's it"
	        }
	      } if (item.likes > 1) {
	        return {
	          gabid: item.gabid,
	          gabtext:item.gabtext,
	          timestamp: moment(item.timestamp).fromNow(),
	          fname:item.fname,
	          likes: item.likes + " likes"
	        }
	      }
	    }),
	    username:req.session.username,
	    userid:req.session.userid
	  }
	  res.render ('homepage', cxt)
	})
})

app.post("/:username/homepage", function(req,res,next){
	const gabid = req.body.gabid
	const sql = `
	INSERT INTO likes (userid, gabid)
	VALUES (?, ?)
	`
	conn.query(sql, [req.session.userid, gabid], function(err, results, fields){
		if (!err){
			res.redirect("/:username/homepage")
		} else {
			next("Oops. Our fault.")
		}
	})
})


app.get ("/:gabid/likes", function(req,res,next){
	
	const sql = `
	SELECT l.*, u.fname
	FROM likes l
	JOIN gabs g ON l.gabid = g.gabid
	JOIN users u ON l.userid = u.userid
	WHERE g.gabid = ?
    ORDER BY l.id DESC;
	`
	conn.query (sql, [req.params.gabid], function(err,results,fields){
		const gabSQL = `
			SELECT 
			    g.*, u.fname
			FROM
			    gabs g
			JOIN
			    users u ON u.userid = g.userid
			WHERE g.gabid = ?
		`
		conn.query(gabSQL,[req.params.gabid], function(err2,results2,fields2){
			var gab = results2[0]
			gab.time = moment(gab.timestamp).format('MMMM Do YYYY, h:mm:ss a')

			var like = {
				likes:results,
				gab:gab,
				username: req.session.username
			}
			res.render ('likes', like)
		})
	})
})
app.get("/homepage", function(req,res,next){
	let path = "/" + req.session.username + "/homepage"
	res.redirect(path)
})

app.use(function(err, req, res, next){
	res.render("error", {
		message: err
	})
})

app.listen(3000, function(){
  console.log("App running on port 3000")
})
