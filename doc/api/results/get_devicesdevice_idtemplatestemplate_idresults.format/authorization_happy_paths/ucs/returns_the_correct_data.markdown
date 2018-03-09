# Results API

## GET devices/:device_id/templates/:template_id/results.:format - authorization happy paths - ucs - returns the correct data

### GET devices/:device_id/templates/:template_id/results.:format
### Request

#### Headers

<pre>Authorization: Basic anVkZV9tYXllcnQ6OXczbTV5NWo=
Host: example.org
Cookie: </pre>

#### Route

<pre>GET devices/54/templates/50/results.c3</pre>

### Response

#### Headers

<pre>X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Content-Type: application/html; charset=utf-8
ETag: W/&quot;83a684f61dd9b4a68f58661ce2816504&quot;
Cache-Control: max-age=0, private, must-revalidate
Set-Cookie: _arcus-service_session=a1ZNaElnL0YrS3lsNGJkdlVEMm9TcWtlVUJ0a0hMT3F3aTJTZkp2Rk9EemdOQ241SnVHZ0VUdDdNeGhUOXRZTzhhTG5JV0xXTURFVWphSEMyV2VDWGc9PS0tOEZ4ZWJJdklXMFFzYjhobzdUbGFqdz09--34736af23d009b3372354a14463af75eeaee3c99; path=/; HttpOnly
X-Request-Id: f8e68643-5421-4f7f-b582-79d48f1faf7c
X-Runtime: 0.041590
Content-Length: 136</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>[{"name":"one","displayName":"a"},{"name":"two","displayName":"b"},{"name":"three","displayName":"c"},{"name":"four","displayName":"d"}]</pre>
