# Dependencies
express = require 'express'
request = require 'request'
fs = require 'fs'
js2xmlparser = require("js2xmlparser")

app = express.createServer()

app.configure ()->
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use(app.router)

app.get '/', (req, res)->
  res.send "Krake translators for custom URLS"

app.post '/json_object_to_html', (req, res)->
  method = req.body.method || "get"
  origin_url = req.body.origin_url

  switch method
    when "get"
      request origin_url, (error, response, body)=>
        if !error && response.statusCode == 200
          res.send js2xmlparser("data", body)
        else
          res.send error

# Assumes we are getting a JSON response and returns an attribute as HTML
#
# Params:
#   method: String
#   origin_url: String
#   attribute: String
app.post '/json_attribute_raw', (req, res)->
  method = req.body.method || "get"
  origin_url = req.body.origin_url
  attribute = req.body.attribute

  console.log "[SERVER_TRANSLATE] #{new Date()} : /json_attribute_raw \n\torigin_url: #{origin_url}\n\tmethod: #{method}\n\tattribute: #{attribute}"

  switch method
    when "get"
      request origin_url, (error, response, body)=>
        if !error && response.statusCode == 200
          output = JSON.parse(body)[attribute]
          res.send output
        else
          res.send error
  
      

exports = module.exports = app

if !module.parent
  console.log 'Translate Server listening at port 9807'
  app.listen 9807
