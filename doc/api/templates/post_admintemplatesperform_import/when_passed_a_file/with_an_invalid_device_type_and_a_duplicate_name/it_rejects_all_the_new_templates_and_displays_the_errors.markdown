# Templates API

## POST /admin/templates/perform_import - when passed a file - with an invalid device type and a duplicate name - it rejects all the new templates and displays the errors

### POST /admin/templates/perform_import

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| file | File containing JSON to upload | false | json_file |
| json_file |  json file | false |  |

### Request

#### Headers

<pre>Cookie: _arcus-service_session=NEFnODA2UEtTeDdiMHg1ZnM2WlRwaXAzcFBsVUlsR2VkbTIzVDZVenA3MGRQdG9CeVh6cEg4Zi9LelppODhCMU5UV2x4ZnJ1bi80MWNSNXllRGdlYlVQK012QlEzNE9ZYnIveXFUa0lJcFg1L3RheHZ6RzlMOE5EaDNucHJKYjg2SEc3MmpKRDVDOEFiZ2ZUenRsc1JuWGp0RHU3a3BvSG1sSERpTTZ2cDlzPS0tOFpXclh2elkyVWI1WlBKK2plOXhFQT09--459352f14a11f4df62f54efcf8f066dd4f4160f1; path=/; HttpOnly
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
Set-Cookie: _arcus-service_session=cTFlVDhRSitsVnNpYzZKM0VHS1hoUEVDNnRMOUpyMUJudmFJR0t4NU1vSTQ1SmNnNjl6Z2o1RjM0Y3NoTlBrZHI2dlowbGhraXJIMnNPMjRsN09NbFpKaUZIZkY0eFBtZXBSTGFMTEZMaGRvNXJCd3BZcXVPcDdYaHdxMUxIcXBmZWFLa1pFSUlPUjlVOEtRMWlKRVQrd0JJWWladGlsNkdWaHZLc1JJWmZRZlBvdkt2NnBlV0F3UGlnTngyNjJFM1JJbHBzWm5kK2lhcUh6Y2JsaDB2L3dRMkVGK0llSTdVd0dSSVBHdlJhb1VDZExXT2RiUFYyNzRYMjBlNWM0RnNvelJSdkFJUFJrTEgwd2Q4NG1nMDFrbFRRTWJWd01FV2RDc2dZb0Y3UXRoTENRV1VTMGRjSTk4aW9nV2N1T2lQMmdEaEhmV09Lb0FFNFdDZEYySm8yZFhveWpDUXVXMGNITXFrTTlLRnhUcDY4bU9nU09TZ21OVnNTOUhXWmpKQUdkYzBRWld5Wmd3S0NIdE0vL3RiS2xJbmV1RTR0bFMyY0ZPanNiSmdWblNETFRKUnVQV3p4c004T2hNTFhHRXlKS1B0NmJOL2JwWURJZEJMY1BUMkJEek5tVWxiMlVCYzdWUWlrcjc3YlU9LS16Ly9KVEwvNzFkR1dic0V5VSs5U1pRPT0%3D--fb4f6234e459e16f80c3c7a3d9db1b561c089a05; path=/; HttpOnly
X-Request-Id: 0092dd4b-0f4d-4e77-a312-053d9a2d408d
X-Runtime: 0.035009
Content-Length: 100</pre>

#### Status

<pre>302 Found</pre>

#### Body

<pre><html><body>You are being <a href="http://example.org/admin/templates">redirected</a>.</body></html></pre>
