# Results API

## GET devices/:device_id/templates/:template_id/results.:format - missing parameter - it returns a 200 with no name and error in displayName

### GET devices/:device_id/templates/:template_id/results.:format
### Request

#### Headers

<pre>Authorization: Basic emV0dGE6Tm9HakFoNHdKdTN3QXE=
Host: example.org
Cookie: </pre>

#### Route

<pre>GET devices/63/templates/59/results.c3</pre>

### Response

#### Headers

<pre>X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Content-Type: application/html; charset=utf-8
ETag: W/&quot;ef520ead374d230b8ebe5598741054c3&quot;
Cache-Control: max-age=0, private, must-revalidate
Set-Cookie: _arcus-service_session=ZUFqQUFMbE1rNWFJaVRpWmY1blV1S0NKYTZiNkswUnd4Smw1YjFsU0ZLd0Yxb2FCOFpzVWhFV1pVU3hPanpsemgzZks5Ui9zb1NvUWpxcjNYWnNERVE9PS0tZHU5bWZtYWVJN0JvWEtOQTFMZ0RHdz09--6f0a1cc1937805a071e79f4bdad130dd52750167; path=/; HttpOnly
X-Request-Id: 2e25da94-add8-4a3e-b0be-66190a86ed36
X-Runtime: 0.009842
Content-Length: 54</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>[{"name":"","displayName":"missing parameter banana"}]</pre>
