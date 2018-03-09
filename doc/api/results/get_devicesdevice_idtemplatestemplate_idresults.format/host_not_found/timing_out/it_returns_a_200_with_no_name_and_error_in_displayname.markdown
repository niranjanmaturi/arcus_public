# Results API

## GET devices/:device_id/templates/:template_id/results.:format - host not found - timing out - it returns a 200 with no name and error in displayName

### GET devices/:device_id/templates/:template_id/results.:format
### Request

#### Headers

<pre>Authorization: Basic bWFyZ2FyZXRfbGFya2luOlZqWnczejd3Ng==
Host: example.org
Cookie: </pre>

#### Route

<pre>GET devices/64/templates/60/results.c3</pre>

### Response

#### Headers

<pre>X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Content-Type: application/html; charset=utf-8
ETag: W/&quot;092d7b126e919a4a072baeae7777111e&quot;
Cache-Control: max-age=0, private, must-revalidate
Set-Cookie: _arcus-service_session=WGx5aUJrTno4ajN0K0Zlc1laRVp1YVBodm9LNzZoNlBKK2tiVjdtaHhTTmJkWFBSM0RENEJFY2dVNDhVeXUyRXVHTUYvc2xYb3pUNGtveXdkZnpLS2c9PS0tdmRoWitMd285VGlQb2JpL216VlZ3dz09--8ba5d9abcf0cf5fd90c72102a2274af614ab4fa8; path=/; HttpOnly
X-Request-Id: 08f93134-fe00-40c2-a2fa-a3267bb3e97a
X-Runtime: 0.012836
Content-Length: 45</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>[{"name":"","displayName":"Host not found."}]</pre>
