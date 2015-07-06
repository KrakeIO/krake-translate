Krake Translator
===

A simple web service that takes a HTTP POST request and translates the corresponding JSON response into a multi-nested JSON
end point

<h2>Making a request</h2>
<pre>
  URL: /crawl
  METHOD: POST

  {
    origin_url: "http://localhost/json_response",
    method: "post"
  }
</pre>

<h2>Response</h2>
<h4>When successfuly</h4>
<pre>
HTTP RESPONSE STATUS: 200

<html>
  <body>
    <div id="attribute1">
      <div id="sub_attribute_1">
        This is the value in the JSON object
      </div>
      <div id="sub_attribute_2">
        This is the value in the second object
      </div>      
    </div>
  </body>
</html>
</pre>

