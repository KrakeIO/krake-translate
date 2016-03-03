# Dependencies
express = require 'express'
request = require 'request'
fs = require 'fs'
js2xmlparser = require("js2xmlparser")

getCookieString = ( cookies )->
  console.log("processing cookies")
  parsed_cookies = JSON.parse cookies

  translated_cookies = parsed_cookies.map (cookie)=>
    cookie["name"] + "=" + cookie["value"]

  cookie_string = translated_cookies.join "; "
  cookie_string

replaceURLs = (body, origin_url)->
  body
    .replace(/href='\//g, "href='//" + origin_url + "/")
    .replace(/href="\//g, 'href="//' + origin_url + '/')
    .replace(/src="\//g, 'src="//' + origin_url + '/')
    .replace(/src="\//g, 'src="//' + origin_url + '/')
    .replace(/href='\//g, "href='//" + origin_url + "/")
    .replace(/<script/g, '<!--script>')
    .replace(/<\/script>/g, '<\/script-->')
  

app = express.createServer()

app.configure ()->
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use(app.router)

app.get '/', (req, res)->
  res.send "Krake translators for custom URLS"

app.post '/raw_html', (req, res)->
  method = req.body.method || "get"
  origin_url = req.body.origin_url
  cookies_to_forward = req.body.post_cookies || "[]"
  cookie_string = getCookieString cookies_to_forward
  options = 
    url: origin_url
    headers: 
      Cookie: cookie_string
  switch method
    when "get"
      request options, (error, response, body)=>
        console.log response.req._headers.host
        if !error && response.statusCode == 200
          body = replaceURLs body, response.req._headers.host
          console.log body
          res.send body
        else
          res.send error

app.post '/json_object_to_html', (req, res)->
  method = req.body.method || "get"
  origin_url = req.body.origin_url
  cookies_to_forward = req.body.post_cookies || []

  cookie_string = getCookieString cookies_to_forward
  options = 
    url: origin_url
    headers: 
      Cookie: cookie_string

  switch method
    when "get"
      request options, (error, response, body)=>
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
  cookies_to_forward = req.body.post_cookies || []

  cookie_string = getCookieString cookies_to_forward
  # cookie_string_2 = "zguid=22|%5B%22c67f40fd-bee9-412a-bb7c-e48bf2026cda%22%2C%22000000%22%2C%22%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%5Cu0000%22%2C%22false%40false%40false%40false%400%400%400%400%400%400%22%2C%220%22%2C%220%22%2C%220%22%2C%2210%22%2C%220%22%2C%220%400%400%400%400%400%22%2C%22%22%5D; abtest=2|iH8xq%2F31poFpe1hv; __gads=ID=16a5ae5a1055e4b4:T=1436086957:S=ALNI_MZBJHln5dTVZrDXDGaNKXoIL0WRsA; userid=X|2|7cea3d0051de639%7C6%7Cloj6ELSt5irrOSZxkPmtcvMGuL8802y1RPrEdBiRjgU%3D; ajs_anonymous_id=%22c2e041a2-2c1b-4057-b99f-db57ab278f8b%22; ajs_user_id=null; ajs_group_id=null; _chartbeat2=BoCvYDCTylt9B8XubH.1436141107294.1436141125206.1; _hp2_id.1532377119=6802419223639939.0231942724.2053287975; olfsk=olfsk9260421963408589; hblid=Nz89KrYZ8GJsPpCv6T6pC0VfDWQ0NEI2; SSM_GFU=eyJ2ZXJzaW9uIjoxLCJndWlkIjoiNTU5OWI5M2MyODJkYzg2OGE3MDAwMjlhIiwibGFzdF9zZWVuIjoxNDM2MTYyNjY0fQ==; SSM_UTC=Z3VpZDo6NTU5OWI5M2MyODJkYzg2OGE3MDAwMjlhfHx8c291cmNlOjpnZnU=; SSM_UTC_LS=Z3VpZDo6NTU5OWI5M2MyODJkYzg2OGE3MDAwMjlhfHx8c291cmNlOjpnZnU=; JSESSIONID=2C58083C930CEC07148C2B96606A6E59; F5P=2468399114.0.0000; ipe_s=38f58e9a-71d7-db9d-6ac7-87ed5336aa99; search=6|1442955022623%7Crect%3D37.844765%252C-122.270108%252C37.696317%252C-122.604504%26zm%3D11%26rid%3D20330%26disp%3Dmap%26mdm%3Dauto%26p%3D1%26z%3D1%26type%3Dhouse%252Ccondo%26fs%3D0%26fr%3D1%26mmm%3D0%26rs%3D0%26ah%3D0%09%01%0920330%09%09%092%090%09US_%09; _gat=1; _bizo_bzid=d06f66d7-7cf1-4d8e-88ea-155a01b0fa8c; _bizo_cksm=C84FA5A57A27D060; _bizo_np_stats=14%3D40%2C; ipe.29115.pageViewedCount=8; _ga=GA1.2.2078189022.1436086955"
  options = 
    url: origin_url
    headers: 
      Cookie: cookie_string

  console.log "[SERVER_TRANSLATE] #{new Date()} : /json_attribute_raw \n\torigin_url: #{origin_url}\n\tmethod: #{method}\n\tattribute: #{attribute}"

  switch method
    when "get"
      request options, (error, response, body)=>
        console.log "\n==== Start Response Body==="
        console.log body
        console.log "\n\n==== End Response Body==="
        if !error && response.statusCode == 200
          output = JSON.parse(body)[attribute]
          res.send output
        else
          res.send error
  
exports = module.exports = app

if !module.parent
  console.log 'Translate Server listening at port 9807'
  app.listen 9807
