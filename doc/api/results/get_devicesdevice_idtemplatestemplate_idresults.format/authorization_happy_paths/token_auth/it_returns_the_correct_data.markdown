# Results API

## GET devices/:device_id/templates/:template_id/results.:format - authorization happy paths - token auth - it returns the correct data

### GET devices/:device_id/templates/:template_id/results.:format
### Request

#### Headers

<pre>Authorization: Basic bmljay5zdGFyazo4dzNkRmVLZEdtWnU4ag==
Host: example.org
Cookie: </pre>

#### Route

<pre>GET devices/55/templates/51/results.c3</pre>

### Response

#### Headers

<pre>X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Content-Type: application/html; charset=utf-8
ETag: W/&quot;e402e3a78ccb60aa01f8d3783df090cf&quot;
Cache-Control: max-age=0, private, must-revalidate
Set-Cookie: _arcus-service_session=VHRHUkJOUk1OMnVuQWE1aXNQVVRvMVNtWEdXaDVra08zSkhCRkNLbXNSd1FnZzhhQ1A5VGNIRGlhemdPQ2JERTR6TVBFMW9kdTE5aUFSVWY2ODFqY0E9PS0tZzUzMitkY0hZQ2pmYVdSVkpDSDhvQT09--942049948813714aa0bba4efb05869ac28fc5bd9; path=/; HttpOnly
X-Request-Id: 19b64d49-35ff-4052-b5b0-87bae78f868e
X-Runtime: 0.029351
Content-Length: 762</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>[{"name":"et0","displayName":"Iste accusamus ipsa molestiae.0"},{"name":"explicabo1","displayName":"Quos error in laborum est ullam suscipit.1"},{"name":"ut2","displayName":"Incidunt veritatis non numquam labore.2"},{"name":"voluptatem3","displayName":"Rerum nam possimus nemo.3"},{"name":"sed4","displayName":"Voluptatum a adipisci et optio temporibus.4"},{"name":"sunt5","displayName":"Expedita tempora aut nulla ab iure.5"},{"name":"exercitationem6","displayName":"Nam quaerat impedit sint expedita magnam maxime hic.6"},{"name":"quidem7","displayName":"Ut delectus rem officiis est aut facilis quis itaque.7"},{"name":"et8","displayName":"Sit ea quaerat fuga.8"},{"name":"praesentium9","displayName":"Rerum ad ut sunt consequatur facere sequi voluptatem.9"}]</pre>
