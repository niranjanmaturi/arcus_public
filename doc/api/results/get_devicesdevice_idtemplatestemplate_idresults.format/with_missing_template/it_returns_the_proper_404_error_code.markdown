# Results API

## GET devices/:device_id/templates/:template_id/results.:format - with missing template - it returns the proper 404 error code

### GET devices/:device_id/templates/:template_id/results.:format
### Request

#### Headers

<pre>Authorization: Basic bWFyaWFuby50cmV1dGVsOjkyUTJGMFdzNTZQc0pyTHk=
Host: example.org
Cookie: </pre>

#### Route

<pre>GET devices/59/templates/83298/results.c3</pre>

### Response

#### Headers

<pre>X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Content-Type: text/plain; charset=utf-8
Cache-Control: no-cache
X-Request-Id: eb2c041e-566b-4383-a4a7-ff70da4cdcf4
X-Runtime: 0.012588
Content-Length: 16</pre>

#### Status

<pre>404 Not Found</pre>

#### Body

<pre>Object not found</pre>
