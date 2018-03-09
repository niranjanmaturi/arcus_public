# Templates API

## POST /admin/templates/perform_import - when passed a file - with multiple duplicate names - it rejects all the new templates and displays the errors

### POST /admin/templates/perform_import

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| file | File containing JSON to upload | false | json_file |
| json_file |  json file | false |  |

### Request

#### Headers

<pre>Cookie: _arcus-service_session=VmFzUXpaN2VZVFp1bk1vaUo0V1pnc09PKzVlQXY0c0dPNXhzZ0VMOU5PbUZrZnIxR3ZBQm5ZeW5aTDFqOGN0YTZlZ0pOVklpUFhoeEIveEgyeVhHckU1NHBVUUxVTUptc01RZlRTbE9oVk1vWlBJS1E1cDZHck4vVDMyQXUwc1FWS3YvakJUTjR4RSs4alkvdWdpU3B5YnYxREVMQUFpdGNiZFN2cWZEQ1VvPS0tS0tVNy9LYlAyVitEek5MWTBQbGFtUT09--0981dc315e73fdd0b5dd5b96da2d04af88e94ed4; path=/; HttpOnly
Host: example.org
Content-Type: multipart/form-data; boundary=----------XnJLe9ZIbbGUYtzPQJ16u1</pre>

#### Route

<pre>POST /admin/templates/perform_import</pre>

#### Body

<pre>------------XnJLe9ZIbbGUYtzPQJ16u1
Content-Disposition: form-data; name="json_file[file]"; filename="generated.json"
Content-Type: application/json
Content-Length: 2379

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
Set-Cookie: _arcus-service_session=OHNrVk0wUkRodDVPeUxjS1dLOXJzem55WHlKbFlWSUZrbnlTazBESFZUNXVwbjgyTFpRdVNWNktZd3RwZ25qNzBrRXpDWVp6a0V3SFlPdjFnbVdiQXNMa1RrclhpOEdheU1xaXMzWDQ3d0R5UW9RZkZxc21yL1kvUHBFMHg3NFNNQ25TbmJQWHpyNGUvbmRIdlpjZ3VLTDYxYnR5WmkyVG84SEE0b3J0QVdoQTFSSGZScHNhclo2L3ZMSStVVUNDMzJHZEpYaEwrVFlCUTlPVTRrSjJMUVZHSnVNQ3FvZURyM0JWNnlOUTBjNXR3MUdBbTEvU0hLaFZDSVdCNTVzaXZaNXY1ZWE5dytIVCtlaEhidHNuKy96L05IM2wvbmx2U2pKMFNwSUtwalBCMkFWRmFhU0Y4NXhFOFgwelBhZlNJTlhydThwQmpFUksreExXQWkvWitBPT0tLXM4MUpIeXZoWHJXbElvL3k2TkhTM1E9PQ%3D%3D--97a4320aa670b2b4a4df7314b2f75bcf651ca0e9; path=/; HttpOnly
X-Request-Id: d4b3e1e7-f31f-425c-9649-71cc401fe083
X-Runtime: 0.027515
Content-Length: 100</pre>

#### Status

<pre>302 Found</pre>

#### Body

<pre><html><body>You are being <a href="http://example.org/admin/templates">redirected</a>.</body></html></pre>
