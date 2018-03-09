# Results API

## GET devices/:device_id/templates/:template_id/results.:format - with missing device - it returns the proper 404 error code

### GET devices/:device_id/templates/:template_id/results.:format
### Request

#### Headers

<pre>Authorization: Basic cGVnZ2llOlZ0SzBTZE1jTTBBZ0xpVQ==
Host: example.org
Cookie: </pre>

#### Route

<pre>GET devices/99701/templates/55/results.c3</pre>

### Response

#### Headers

<pre>X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Content-Type: text/plain; charset=utf-8
Cache-Control: no-cache
X-Request-Id: 3a1860f6-ad1d-4336-9475-396c0e4f3a65
X-Runtime: 0.017446
Content-Length: 16</pre>

#### Status

<pre>404 Not Found</pre>

#### Body

<pre>Object not found</pre>
