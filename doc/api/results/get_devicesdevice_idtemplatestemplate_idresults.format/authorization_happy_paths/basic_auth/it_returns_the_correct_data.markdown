# Results API

## GET devices/:device_id/templates/:template_id/results.:format - authorization happy paths - basic auth - it returns the correct data

### GET devices/:device_id/templates/:template_id/results.:format
### Request

#### Headers

<pre>Authorization: Basic a2VsbGVuLnVwdG9uOjBoMmlHdVhuWThCOA==
Host: example.org
Cookie: </pre>

#### Route

<pre>GET devices/57/templates/53/results.c3</pre>

### Response

#### Headers

<pre>X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Content-Type: application/html; charset=utf-8
ETag: W/&quot;d926adfda1137dbe9924d5c18e22e20c&quot;
Cache-Control: max-age=0, private, must-revalidate
Set-Cookie: _arcus-service_session=cEJjSE1UMHVvWVR5YzlFL3diZW9YdU9RbnVqTlFnRnQ1OVFtaXVEUHRJSFI1TjZ6bkpKL2ZFU3BBR1A0YUE5aTYyVk1GREVqLytGWWdJemFUMmtxVVE9PS0tT3hmbDdUMXo1cHRtdUYrdEphbDhiQT09--525469f0d06f92973328b29502f896a3a3d11c37; path=/; HttpOnly
X-Request-Id: c3064632-e237-4e49-9720-fb3f95914c1d
X-Runtime: 0.018354
Content-Length: 736</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>[{"name":"aut0","displayName":"Ad consequuntur nobis incidunt magnam et neque beatae.0"},{"name":"repudiandae1","displayName":"Id ut dolor aut laboriosam.1"},{"name":"recusandae2","displayName":"Nemo omnis nobis rem quia provident.2"},{"name":"unde3","displayName":"Quaerat et sed possimus.3"},{"name":"reiciendis4","displayName":"Commodi debitis sint ipsum suscipit.4"},{"name":"mollitia5","displayName":"Mollitia tenetur asperiores nam deleniti vitae provident ut dolor.5"},{"name":"saepe6","displayName":"Eum ut dolor minus iure sint.6"},{"name":"blanditiis7","displayName":"Qui quaerat esse provident quis.7"},{"name":"aut8","displayName":"Ipsam aut ea dolor magnam.8"},{"name":"culpa9","displayName":"Aut ex omnis nesciunt est.9"}]</pre>
