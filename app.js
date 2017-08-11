const express = require('express')
const app = express()
const path = require('path')
const mustacheExpress = require('mustache-express');
const bodyParser = require('body-parser')
const config = require('config')

app.use(bodyParser.urlencoded({extended:false}))
app.use(bodyParser.json())
app.engine('mustache', mustacheExpress())
app.set('views', './views')
app.set('view engine', 'mustache')
app.use(express.static(path.join(__dirname, 'static')))

// before you use this, make sure to update the default.json file in /config
// const conn = mysql.createConnection({
//   host: config.get('db.host'),
//   database: config.get('db.database'),
//   user: config.get('db.user'),
//   password: config.get('db.password')
// })

app.get("/", function(req, res, next){
	res.render("login")
})

// app.get("/signup", function(req,res,next){
// 	res.render ("signup")
// })

app.get("/gab", function(req,res,next){
	res.render("gab")
})

app.listen(3000, function(){
  console.log("App running on port 3000")
})
