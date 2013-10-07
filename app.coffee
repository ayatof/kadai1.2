
###
Module dependencies.
###
express = require("express")
routes = require("./routes")
user = require("./routes/user")
http = require("http")
path = require("path")
passport = require("passport")
TwitterStrategy = require("passport-twitter").Strategy
app = express()

# all environments
app.set "port", process.env.PORT or 3000
app.set "views", __dirname + "/views"
app.set "view engine", "ejs"
app.use express.favicon()
app.use express.logger("dev")
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser("your secret here")
app.use express.session()
app.use passport.initialize()
app.use passport.session()
app.use app.router
app.use express.static(path.join(__dirname, "public"))

# development only
app.use express.errorHandler()  if "development" is app.get("env")
app.get "/", routes.index
http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")


# serialize, deserialize
passport.serializeUser (user, done) ->
  done null, user

passport.deserializeUser (obj, done) ->
  done null, obj


# Authenticate Twitter
passport.use new TwitterStrategy(
  consumerKey: "4NTNxYcAuS55LmCbYyn9kA"
  consumerSecret: "lVtnrMzISrYQUscso7Bj7tAHTFdPJhXeFSSM5VbY"
  callbackURL: "http://127.0.0.1:3000/auth/twitter/callback"
, (token, tokenSecret, profile, done) ->
  passport.session.accessToken = token
  passport.session.profile = profile
  process.nextTick ->
    done null, profile

)

#
#参考:
#http://creator.cotapon.org/articles/node-js/node_js-oauth-passport-facebook-twitter
#http://creator.cotapon.org/articles/node-js/node_js-oauth-twitter
#
#process.NextTickについて
#http://howtonode.org/understanding-process-next-tick
#http://d.hatena.ne.jp/sasaplus1/20120507/1336396704
#
