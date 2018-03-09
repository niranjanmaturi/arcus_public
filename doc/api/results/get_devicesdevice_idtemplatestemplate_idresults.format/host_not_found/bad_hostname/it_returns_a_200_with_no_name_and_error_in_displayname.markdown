# Results API

## GET devices/:device_id/templates/:template_id/results.:format - host not found - bad hostname - it returns a 200 with no name and error in displayName

### GET devices/:device_id/templates/:template_id/results.:format
### Request

#### Headers

<pre>Authorization: Basic bGFtYXI6TXBTbE5jRWw=
Host: example.org
Cookie: </pre>

#### Route

<pre>GET devices/65/templates/61/results.c3</pre>

### Response

#### Headers

<pre>X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Content-Type: application/html; charset=utf-8
ETag: W/&quot;092d7b126e919a4a072baeae7777111e&quot;
Cache-Control: max-age=0, private, must-revalidate
Set-Cookie: _arcus-service_session=ZE9iQU1nK2NLRWlyZXVvS0FSczdaS24vbTZjZjV2aW44dWNtRFAvclNsWUFTMHFkYXdXVjRmM2RxWmE0enpXb1NyMXZZUFBtYUc0SWgvOE1lRGIzZGc9PS0tSTM3SVdRZ04vR2VzazJKWmNjcnZmdz09--190cc280462e8897d335aa14b34c2cb03a20c1e1; path=/; HttpOnly
X-Request-Id: ae1dc22d-e33d-4f1e-b6ce-c29a7f8c287e
X-Runtime: 0.013375
Content-Length: 45</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>[{"name":"","displayName":"Host not found."}]</pre>
