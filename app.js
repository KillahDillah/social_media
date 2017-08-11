const express = require('express')
const app = express()
const path = require('path')
const mustacheExpress = require('mustache-express');
const bodyParser = require('body-parser')
const config = require('config')
const hash = require('js-sha512')
const mysql = require('mysql')
const session = require('express-session')

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
      res.redirect("/gab")
    } else {
      res.send ('Username and password do not match')  // username and password not correct 
      }
   })
})

app.post("/signup", function(req,res,next){
	const fname = req.body.firstname
	const lname = req.body.lastname
	const username = req.body.desired_username
	const password = hash(req.body.password)

	const sql = `
	INSERT INTO users (fname, lname, username, password)
	VALUES (?,?,?,?)
	`

	conn.query(sql,[fname,lname,username,password], function(err,results,fields){
		if (!err){
			res.redirect("/gab")
		} else {
			res.send ("Username already taken")
		}
	})
})


app.get("/gab", function(req,res,next){
	res.render("gab", { username:req.session.username})
})

app.get ("/homepage", function(req,res,next){
	const sql = `
	SELECT *
	FROM gabs
	ORDER BY gabid DESC
	LIMIT 10
	`

	conn.query (sql, function(err,results,fields){
		var cxt = {
			gabs:results
		}
		res.render ('homepage', cxt)
	})
})

app.post("/gab", function(req,res,next){
	const gab = req.body.newgab

	const sql = `
		INSERT INTO gabs (gabtext)
		VALUES (?)
	`

	conn.query(sql, [gab], function(err,results,fields){
		if (!err) {
			res.redirect("/homepage") 
		} else {
			res.send ("Danger!")
		}
	})
})

app.listen(3000, function(){
  console.log("App running on port 3000")
})
