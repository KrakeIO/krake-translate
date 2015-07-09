Krake Translator
===

A simple web service that takes a HTTP POST request and translates the corresponding JSON response into a multi-nested JSON
end point

<h2>Making a request</h2>
```json
  URL: /json_object_to_html
  METHOD: POST

  {
    origin_url: "http://localhost/json_response",
    method: "post"
  }
```

<h2>Actual response from data source</h2>
```json
  HTTP RESPONSE STATUS: 200
  content-type: application/json

  {
    attribute_1: {
      sub_attribute_1: "This is the first value in the JSON object",
      sub_attribute_2: "This is the second value in the second object"
    },
    attribute_2: "This is another value"
  }
```

<h2>Response</h2>
<h4>When successfuly</h4>
```html
  HTTP RESPONSE STATUS: 200

  <html>
    <body>
      <div id="attribute_1">
        <div id="sub_attribute_1">
          This is the first value in the JSON object
        </div>
        <div id="sub_attribute_2">
          This is the second value in the second object
        </div>      
      </div>
      <div id="attribute_2">
        This is another value
      </div>
    </body>
  </html>
```

