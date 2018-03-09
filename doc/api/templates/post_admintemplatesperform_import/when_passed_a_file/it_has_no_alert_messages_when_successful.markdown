# Templates API

## POST /admin/templates/perform_import - when passed a file - it has no alert messages when successful

### POST /admin/templates/perform_import

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| file | File containing JSON to upload | false | json_file |
| json_file |  json file | false |  |

### Request

#### Headers

<pre>Cookie: _arcus-service_session=aUZWZFh6WXdTUHIzaG1hWGVQdXB4Q2VsWXFndmJDTFdBalZVL2lBRlduZFRqejJPOXlhSWFmYXRvRkRERkdMSTdzUXBjaTRRVkh6S2NjVG1oU2c2ZERreFNTYndzaDZpd1Jld1M2dzZEQ25sWEdKQ28zTk1xdUdMWFVBc1ZOUEFyUzVkbmxoL2NmdDFEaXpWU0VEcnY1djdpUngzOVo0aWZOb0ROSkdSbExJPS0tV2lmMjkvVjU3UXZ6SzNjMnA0dmZJUT09--f98ebc672d3edbd86e9dc339a33dd0eb635b832b; path=/; HttpOnly
Host: example.org
Content-Type: multipart/form-data; boundary=----------XnJLe9ZIbbGUYtzPQJ16u1</pre>

#### Route

<pre>POST /admin/templates/perform_import</pre>

#### Body

<pre>------------XnJLe9ZIbbGUYtzPQJ16u1
Content-Disposition: form-data; name="json_file[file]"; filename="generated.json"
Content-Type: application/json
Content-Length: 2371

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
Set-Cookie: _arcus-service_session=cFVETGFBd3N3ZE1nOGx0bnhqalNsVmFIN2JOK1ZBNk1uUGoyZm91dHd0MWtvSDBlTFJZNytuSGNzQm1QUmtKTERWRTVlNVFITXQ5cUIvN3hVamlRRzFRVk4vSERxdW5MS1BHNmFZNlJ0NTUwQWQyNVJPbSsrMFJWMmJIZ2dLNUR6MjVaQkVQaGJoSC9VMXpEYUhuUTh4dmI1WW82V1RJdU5aZHBqSXpIa1VnPS0td1BHdHRWS29wNkNOY3poZ01QVmI3dz09--9bbf8920012822ab81b0634ebbcef2816b8e8f27; path=/; HttpOnly
X-Request-Id: 6603b263-d999-4d10-99d8-4a63a29b22c7
X-Runtime: 0.027989
Content-Length: 100</pre>

#### Status

<pre>302 Found</pre>

#### Body

<pre><html><body>You are being <a href="http://example.org/admin/templates">redirected</a>.</body></html></pre>
