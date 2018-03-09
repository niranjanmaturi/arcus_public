# Templates API

## POST /admin/templates/perform_import - when passed a file - with an invalid device type - it rejects all the new templates and displays the errors

### POST /admin/templates/perform_import

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| file | File containing JSON to upload | false | json_file |
| json_file |  json file | false |  |

### Request

#### Headers

<pre>Cookie: _arcus-service_session=dGJyUEY3NVd0cnR5UmdLR2N0Z0lWUkRCSjluSGRicXJEWVF2MzhFSmp5Nmd0VEJmNnRUaSs3YnZCN2lvL2pXblJyWWJkTityR0NpR1FWZVB2VzBIWjBYSHZMNUtmUTY3RWtxNXpiSitjbVRTSk04cVhHWnBrVkQrWm5GVGlrZUlWVmdiOTdQazE1ZnBLaS9CY1dDWWYwcUpQVS9jR1ZydWJOM1A5YW5zY0hvPS0tMGp5aGY2dUg2MzNjN0tNMzRlSUx4Zz09--890c86eee7875f9c9c474339eba77f0e7fd89122; path=/; HttpOnly
Host: example.org
Content-Type: multipart/form-data; boundary=----------XnJLe9ZIbbGUYtzPQJ16u1</pre>

#### Route

<pre>POST /admin/templates/perform_import</pre>

#### Body

<pre>------------XnJLe9ZIbbGUYtzPQJ16u1
Content-Disposition: form-data; name="json_file[file]"; filename="generated.json"
Content-Type: application/json
Content-Length: 2383

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
Set-Cookie: _arcus-service_session=cURmazZPZjg4Tml1aGhvNm5oUisraG0rc1UzMERYU3IyR0hHNFpTL1hnZ283TU45Rm15UW5nV0tHVHc2ZjE5WGZJZVFDMzYxK0pJc1o3RFpLTWh4U0Jna3YxaytxenJOd1dUTGZxT0F4UGUvQlBobE5IUUl6RThVZmlETHZBUjZFZFhPZDQ5WWw5bnU0elB1OTF4M1VtSXVLWW1zYUtJU0tZMCs1allhMkh1QmVvTWRpQ1FGSFBIV0QvemoxRVNjYzdVSlUzQ0JrQWNmS2kwL0pGQThWTXBsUWU5TlhXZ0duM3prMDJzY3dJRWJrSVRMYTJyT3g3WWFnTk9MZzhCZ0EzdnVHSTFjMVN5OVZiakJjWVdLUEIxaW9MUjR0NFhmMG96MEtHRDZWdzA5bGwrQ1RuNDZlTTgyZmZwU09DTjF5MmphVm96Y0ZtdHM0UjAwOTE4WU1sSXZTWHgrSkw5a3hZbWJyd24wZzBwWVpHTzVUYjR2azhYSGlINTJTNVRuZ2NJRCs4cHhPOTFqZEFhQnJlWXhqWnVWNVphL3NwL0Zjam9TT0F1NXNBST0tLWk2dEROZ3I2RllVRGo4UUxCR25Db0E9PQ%3D%3D--d4d59a45791277efb8762317021c6ede24166d74; path=/; HttpOnly
X-Request-Id: d68395e3-03e1-4f6f-af3f-091ac02a4cc5
X-Runtime: 0.030805
Content-Length: 100</pre>

#### Status

<pre>302 Found</pre>

#### Body

<pre><html><body>You are being <a href="http://example.org/admin/templates">redirected</a>.</body></html></pre>
