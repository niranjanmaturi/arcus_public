# Templates API

## POST /admin/templates/perform_import - when the file does not contain JSON - it redirects to the index page with a warning

### POST /admin/templates/perform_import

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| file | File containing JSON to upload | false | json_file |
| json_file |  json file | false |  |

### Request

#### Headers

<pre>Cookie: _arcus-service_session=Vk1pZkE0bktManRneHdqWUlQYyt4d3FMRW5IUldIOFFlcHlRa1hvQXVMakpzTHc3NXViRW8xc2V5TDcwNFNjRThoUkhoUEdtN3ZnS2o3TGM0eC9CRXkrREpiRDUzZHNMbm9JZmg4N25TK2tIL3lhVzJCUVNLREtjNmpYRTF1cml2RUxGcVE0a3VybXNabEdSeDl3QU9MZWtFVFo3WEtzeFk3RDk4eUxxR29jPS0tTmZUbWZBdHg3czNOcHgxRXZyREppdz09--e1d98da400a2cc64539f01692fee1c87b2dc6c23; path=/; HttpOnly
Host: example.org
Content-Type: multipart/form-data; boundary=----------XnJLe9ZIbbGUYtzPQJ16u1</pre>

#### Route

<pre>POST /admin/templates/perform_import</pre>

#### Body

<pre>[uploaded data]-[uploaded data]-[uploaded data]-[uploaded data]-[uploaded data]-[uploaded data]-[uploaded data]-[uploaded data]-[uploaded data]-[uploaded data]-[uploaded data]-[uploaded data]-[uploaded data]X[uploaded data]n[uploaded data]J[uploaded data]L[uploaded data]e[uploaded data]9[uploaded data]Z[uploaded data]I[uploaded data]b[uploaded data]b[uploaded data]G[uploaded data]U[uploaded data]Y[uploaded data]t[uploaded data]z[uploaded data]P[uploaded data]Q[uploaded data]J[uploaded data]1[uploaded data]6[uploaded data]u[uploaded data]1[uploaded data][uploaded data]
[uploaded data]C[uploaded data]o[uploaded data]n[uploaded data]t[uploaded data]e[uploaded data]n[uploaded data]t[uploaded data]-[uploaded data]D[uploaded data]i[uploaded data]s[uploaded data]p[uploaded data]o[uploaded data]s[uploaded data]i[uploaded data]t[uploaded data]i[uploaded data]o[uploaded data]n[uploaded data]:[uploaded data] [uploaded data]f[uploaded data]o[uploaded data]r[uploaded data]m[uploaded data]-[uploaded data]d[uploaded data]a[uploaded data]t[uploaded data]a[uploaded data];[uploaded data] [uploaded data]n[uploaded data]a[uploaded data]m[uploaded data]e[uploaded data]=[uploaded data]"[uploaded data]j[uploaded data]s[uploaded data]o[uploaded data]n[uploaded data]_[uploaded data]f[uploaded data]i[uploaded data]l[uploaded data]e[uploaded data][[uploaded data]f[uploaded data]i[uploaded data]l[uploaded data]e[uploaded data]][uploaded data]"[uploaded data];[uploaded data] [uploaded data]f[uploaded data]i[uploaded data]l[uploaded data]e[uploaded data]n[uploaded data]a[uploaded data]m[uploaded data]e[uploaded data]=[uploaded data]"[uploaded data]b[uploaded data]a[uploaded data]d[uploaded data].[uploaded data]j[uploaded data]s[uploaded data]o[uploaded data]n[uploaded data]"[uploaded data][uploaded data]
[uploaded data]C[uploaded data]o[uploaded data]n[uploaded data]t[uploaded data]e[uploaded data]n[uploaded data]t[uploaded data]-[uploaded data]T[uploaded data]y[uploaded data]p[uploaded data]e[uploaded data]:[uploaded data] [uploaded data]a[uploaded data]p[uploaded data]p[uploaded data]l[uploaded data]i[uploaded data]c[uploaded data]a[uploaded data]t[uploaded data]i[uploaded data]o[uploaded data]n[uploaded data]/[uploaded data]j[uploaded data]s[uploaded data]o[uploaded data]n[uploaded data][uploaded data]
[uploaded data]C[uploaded data]o[uploaded data]n[uploaded data]t[uploaded data]e[uploaded data]n[uploaded data]t[uploaded data]-[uploaded data]L[uploaded data]e[uploaded data]n[uploaded data]g[uploaded data]t[uploaded data]h[uploaded data]:[uploaded data] [uploaded data]0[uploaded data][uploaded data]
[uploaded data][uploaded data]
[uploaded data][uploaded data]
[uploaded data]-[uploaded data]-[uploaded data]-[uploaded data]-[uploaded data]-[uploaded data]-[uploaded data]-[uploaded data]-[uploaded data]-[uploaded data]-[uploaded data]-[uploaded data]-[uploaded data]X[uploaded data]n[uploaded data]J[uploaded data]L[uploaded data]e[uploaded data]9[uploaded data]Z[uploaded data]I[uploaded data]b[uploaded data]b[uploaded data]G[uploaded data]U[uploaded data]Y[uploaded data]t[uploaded data]z[uploaded data]P[uploaded data]Q[uploaded data]J[uploaded data]1[uploaded data]6[uploaded data]u[uploaded data]1[uploaded data]-[uploaded data]-[uploaded data][uploaded data]</pre>

### Response

#### Headers

<pre>X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Location: http://example.org/admin/templates
Content-Type: text/html; charset=utf-8
Cache-Control: no-cache
Set-Cookie: _arcus-service_session=bVVqYXdqcEl5YmFJYXVCZUMyK1VtUGxIWS9yU2pDeU9NVkVCR2Z6WjFQc245WUlGNmw1WFZnZDlDS1ZRNUI2Z2J5bElIT1AvREVLcUtQaFdOcG9hK2liemZOZU8zMlZXOGxmUHJwWi9MYjlyVGE1eW5ISzdWZlNEaCtNbXlNL0xsZ3ZremZNRFBFajVWaG1FVVEvbE1xM3BpUHpVTVlvRGptb2M0c29ENjV2eDFXOEFvYnR0clZ6N3N5aGNZenE2bENEaUlDQ1h0OVJ5QkJCekpqNndueGo4Ulh1RW9yT3lyWVk5S0h5NW1NT3ZJVjVmTkFpcDFmNWd2L09MMW5hUzF3U2d2MUVrdTZINEJiYWJ4N0Rra0E9PS0temlaNmErVWt5bXV6cVJPNWFrZHhHdz09--f4ed43ce13e4ae895bbd4de6609694ff0ef101b0; path=/; HttpOnly
X-Request-Id: 3c607b73-8a7e-4554-ada9-385b3f139313
X-Runtime: 0.004171
Content-Length: 100</pre>

#### Status

<pre>302 Found</pre>

#### Body

<pre><html><body>You are being <a href="http://example.org/admin/templates">redirected</a>.</body></html></pre>
