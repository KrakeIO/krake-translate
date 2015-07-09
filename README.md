Krake Translator
===

A simple web service that takes a HTTP POST request and translates the corresponding JSON response into a multi-nested JSON
end point

<h3>Making a request to translate JSON to HTML</h3>
```http
  URL: /json_object_to_html
  METHOD: POST

  {
    "origin_url": "http://localhost/json_response",
    "method": "post"
  }
```

<h3>Actual response from data source</h3>
```http
  HTTP RESPONSE STATUS: 200
  content-type: application/json

  {
    "attribute_1": {
      "sub_attribute_1": "This is the first value in the JSON object",
      "sub_attribute_2": "This is the second value in the second object"
    },
    "attribute_2": "This is another value"
  }
```

<h3>Response from translation service</h3>
<h5>When successful</h5>
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


<h3>Making a request to return an attribute in a JSON response as HTML</h3>
```http
  URL: /json_attribute_raw
  METHOD: POST

  {
    "origin_url": "http://localhost/json_attribute_raw",
    "method": "post",
    "attribute": "html_attribute"
  }
```

<h3>Actual response from data source</h3>
```http
  HTTP RESPONSE STATUS: 200
  content-type: application/json

  {
    "html_attribute": "<div>This is some cool stuff</div><div>I really like it</div>"
  }
```

<h3>Response from translation service</h3>
<h5>When successful</h5>
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