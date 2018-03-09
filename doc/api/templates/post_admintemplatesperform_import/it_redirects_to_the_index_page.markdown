# Templates API

## POST /admin/templates/perform_import - it redirects to the index page

### POST /admin/templates/perform_import

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| file | File containing JSON to upload | false | json_file |
| json_file |  json file | false |  |

### Request

#### Headers

<pre>Cookie: _arcus-service_session=YXVSblBsclBnbDhLbHhPWng4b1Y2Tm82cVRDL0JQTkkyVmZlK09FSGNBbWRGYUZ3RWRYTHlSNmZOdGhxRHdLN0xIeFBGelQzQUo3VzR1TlpKaUhBK1VtVE5Wd3N3d1E5c2pobWNrWjlCUm8vMWNNMnQ1Nmk2SmNXNzhTMUlyOU5Gems3WEFENTVITnVXY21ncHZJelRhQnFldDhSTGpQZ0FrUXYweGVGVWxrPS0tWEtTQXhWbmdSQ0NhNldBYWIzTEFXZz09--79134e3fdcefcaadf4f763e50a608e08ac19fdb0; path=/; HttpOnly
Host: example.org
Content-Type: multipart/form-data; boundary=----------XnJLe9ZIbbGUYtzPQJ16u1</pre>

#### Route

<pre>POST /admin/templates/perform_import</pre>

#### Body

<pre>------------XnJLe9ZIbbGUYtzPQJ16u1
Content-Disposition: form-data; name="json_file[file]"; filename="generated.json"
Content-Type: application/json
Content-Length: 2400

[uploaded data]
------------XnJLe9ZIbbGUYtzPQJ16u1--</pre>

### Response

#### Headers

<pre>X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Location: http://example.org/admin/templates
Content-Type: text/html; charset=utf-8
Cache-Control: no-cache
Set-Cookie: _arcus-service_session=RUs1RnA0SEQzQldKK3VodmtTelZHU01EZFZjSlFCTUpuTStuZ0NFT0t0Y2g4T0J5ZURsaEFLN3p4cmI0VVZXcTRIYWVYNG4xUDVkb1ZtMVpTcmcvWFJ0bGI3RGRYRW1rQWdZQ2JFd1QzVDRPSDFHUGZPb1hwTlRjaTlkV0FYSU13REdsU1FTWE0za1VrZkdXdDc4Nlo2aDJXNERWWm9JMWxzTU4wWWVGbGdRPS0tM1Z6UVpRSWZBci9jaDBvcnAyUWdUQT09--12b8c8792507fedc13e115dac1a51140b9085bf8; path=/; HttpOnly
X-Request-Id: e3a2a61d-b18c-4ad2-87b5-3c834e4009ea
X-Runtime: 0.039408
Content-Length: 100</pre>

#### Status

<pre>302 Found</pre>

#### Body

<pre><html><body>You are being <a href="http://example.org/admin/templates">redirected</a>.</body></html></pre>
