# Results API

## GET devices/:device_id/templates/:template_id/results.:format - host not found - connection refused - it returns a 200 with no name and error in displayName

### GET devices/:device_id/templates/:template_id/results.:format
### Request

#### Headers

<pre>Authorization: Basic ZGVqb246OXA0alA0VGhN
Host: example.org
Cookie: </pre>

#### Route

<pre>GET devices/66/templates/62/results.c3</pre>

### Response

#### Headers

<pre>X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Content-Type: application/html; charset=utf-8
ETag: W/&quot;092d7b126e919a4a072baeae7777111e&quot;
Cache-Control: max-age=0, private, must-revalidate
Set-Cookie: _arcus-service_session=ZnpQUXNPdi9JeG10bUlwMlNtc0RZM1ZZcU9hcHArM204eHlGMTRzV3RTMFAzNGtKMjNMMkFBZVhhcndkTktYbE5oNExNRlBtWGVoejB2TkJSZjZqRmc9PS0tb25xa0tVeklGNmlPaGYvYTAya01lQT09--417c68d950ef7c9f6beda6bfaa4d6da8b21390ef; path=/; HttpOnly
X-Request-Id: e4238893-f20d-4436-a566-a359a0078af3
X-Runtime: 0.010015
Content-Length: 45</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>[{"name":"","displayName":"Host not found."}]</pre>
