# Templates API

## POST /admin/templates/perform_import - when passed a file - it creates the templates from the file

### POST /admin/templates/perform_import

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| file | File containing JSON to upload | false | json_file |
| json_file |  json file | false |  |

### Request

#### Headers

<pre>Cookie: _arcus-service_session=MkV0Kzh3RHQ2NlliZlRYU3dNRDc4NEZPcGVJaDMybUpjR0VuSndnMTRTMGwyejZ2OXorelc0NDArZ0N5enJiN1dsaExnc09WN0orbzIyeGlJTEJYWmpUc0VRT3pBVzM0UkpiVloweXc1U1Y3OGlFYmNINXAwS1dJLzUybFE1aTFYb3IvSW1GemoyUGNnREVYUGJWNFFWZTF3TlJkelVDOWVhSkIwbnpObHIwPS0tTExDdjhpYkRKLy81L2VlYlRLRlRYdz09--f2f5841fcb0d3ef34c8c9d3ac587821d68bcaae8; path=/; HttpOnly
Host: example.org
Content-Type: multipart/form-data; boundary=----------XnJLe9ZIbbGUYtzPQJ16u1</pre>

#### Route

<pre>POST /admin/templates/perform_import</pre>

#### Body

<pre>------------XnJLe9ZIbbGUYtzPQJ16u1
Content-Disposition: form-data; name="json_file[file]"; filename="generated.json"
Content-Type: application/json
Content-Length: 2351

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
Set-Cookie: _arcus-service_session=Mjl4NHJnK2lCeWNIZzkrNm5ReC9UaVRpNmFTTDRGZFl0d29rcE9TTnVSTVN2WVVRa1VZc2pOOFlRcFc2TjhlVEE1aGtrOXpyN1hQelB2MDBlbWRHLzg1b3BtVmdjVVNYMzFKU2VWcjZEV0UrbHNuUENPbVh4WGV3Q3dvUGR1Q1JRNjlhQ0xKTVhWQlZ0SzJuOVR2S0tvdDJJaGFTOC9JenJGSnZrZHlpbXZRPS0tRGNUbk9JbHdQaFkzNU1oK0NXbEw1dz09--1b70f2bf9fd819298800ca34aa836b420ebea204; path=/; HttpOnly
X-Request-Id: c94f9abb-c08c-4d75-b354-ee68f673ded1
X-Runtime: 0.027620
Content-Length: 100</pre>

#### Status

<pre>302 Found</pre>

#### Body

<pre><html><body>You are being <a href="http://example.org/admin/templates">redirected</a>.</body></html></pre>
