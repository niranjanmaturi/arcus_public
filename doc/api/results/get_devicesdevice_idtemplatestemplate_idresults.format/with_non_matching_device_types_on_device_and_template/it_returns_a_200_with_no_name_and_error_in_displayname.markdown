# Results API

## GET devices/:device_id/templates/:template_id/results.:format - with non matching device types on device and template - it returns a 200 with no name and error in displayName

### GET devices/:device_id/templates/:template_id/results.:format
### Request

#### Headers

<pre>Authorization: Basic YW1icm9zZTo3dlJlRXdNb0F2
Host: example.org
Cookie: </pre>

#### Route

<pre>GET devices/60/templates/56/results.c3</pre>

### Response

#### Headers

<pre>X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Content-Type: application/html; charset=utf-8
ETag: W/&quot;8124e78ad4531ba01c367e4c8008c542&quot;
Cache-Control: max-age=0, private, must-revalidate
X-Request-Id: 4765d54c-88fc-4694-a6cb-5e4b5db8f5d5
X-Runtime: 0.002926
Content-Length: 71</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>[{"name":"","displayName":"Device type does not match template type."}]</pre>
