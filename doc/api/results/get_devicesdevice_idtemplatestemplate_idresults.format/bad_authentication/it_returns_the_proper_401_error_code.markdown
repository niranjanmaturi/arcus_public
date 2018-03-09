# Results API

## GET devices/:device_id/templates/:template_id/results.:format - bad authentication - it returns the proper 401 error code

### GET devices/:device_id/templates/:template_id/results.:format
### Request

#### Headers

<pre>Authorization: Basic dXNlcm5hbWU6cGFzc3dvcmQ=
Host: example.org
Cookie: </pre>

#### Route

<pre>GET devices/62/templates/58/results.c3</pre>

### Response

#### Headers

<pre>WWW-Authenticate: Basic realm=&quot;Application&quot;
Content-Type: #&lt;Mime::NullType:0x007ff85a861050&gt;; charset=utf-8
Cache-Control: no-cache
X-Request-Id: 74e1fd21-3f28-49db-a6ac-6badb1b09943
X-Runtime: 0.007673
Content-Length: 29</pre>

#### Status

<pre>401 Unauthorized</pre>

#### Body

<pre>Invalid Username or password.</pre>
