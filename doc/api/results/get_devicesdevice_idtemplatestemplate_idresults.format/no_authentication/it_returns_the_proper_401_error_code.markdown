# Results API

## GET devices/:device_id/templates/:template_id/results.:format - no authentication - it returns the proper 401 error code

### GET devices/:device_id/templates/:template_id/results.:format
### Request

#### Headers

<pre>Authorization: 
Host: example.org
Cookie: </pre>

#### Route

<pre>GET devices/61/templates/57/results.c3</pre>

### Response

#### Headers

<pre>WWW-Authenticate: Basic realm=&quot;Application&quot;
Content-Type: #&lt;Mime::NullType:0x007ff85a861050&gt;; charset=utf-8
Cache-Control: no-cache
X-Request-Id: f1a4f458-12ac-4fb7-a165-1d33ec50c73e
X-Runtime: 0.007555
Content-Length: 49</pre>

#### Status

<pre>401 Unauthorized</pre>

#### Body

<pre>You need to sign in or sign up before continuing.</pre>
