# Results API

## GET devices/:device_id/templates/:template_id/results.:format - authorization happy paths - with parameter - it returns the correct data

### GET devices/:device_id/templates/:template_id/results.:format

### Parameters

| Name | Description | Required | Scope |
|------|-------------|----------|-------|
| banana |  banana | false |  |

### Request

#### Headers

<pre>Authorization: Basic bm9yd29vZDpFZldwUXoxZU9tVW8=
Host: example.org
Cookie: </pre>

#### Route

<pre>GET devices/58/templates/54/results.c3?banana=weber</pre>

#### Query Parameters

<pre>banana: weber</pre>

### Response

#### Headers

<pre>X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Content-Type: application/html; charset=utf-8
ETag: W/&quot;0bb8cbdc92485a64c686ebac7bff9710&quot;
Cache-Control: max-age=0, private, must-revalidate
Set-Cookie: _arcus-service_session=d2paaUJ3eWwvbnBjRWJHczNWOWgvc3FYNVpOQ3FqeHJWdW9IaXNQSkN4SmdpYm80S1lLdnByWmJRSko5eXZjS0grK1h1anI0bDFaVnJ2QnhIYnB4dFE9PS0tTzFPTEovVmdqRUdKYXZLM3V2RHhQQT09--f507714ec333721cea710a622a4f263b3caf0e46; path=/; HttpOnly
X-Request-Id: 66acc5fc-0cf4-427c-a3f6-a61a73d75e65
X-Runtime: 0.017230
Content-Length: 789</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>[{"name":"sint0","displayName":"Libero tempore in aperiam.0"},{"name":"autem1","displayName":"Similique sunt dolor voluptas id.1"},{"name":"ab2","displayName":"Voluptatibus dolor recusandae ea qui.2"},{"name":"alias3","displayName":"Quidem odit error occaecati.3"},{"name":"ut4","displayName":"Eum ipsam ut architecto odio illum officia voluptatum.4"},{"name":"cupiditate5","displayName":"Praesentium sed velit optio.5"},{"name":"delectus6","displayName":"Voluptates cumque similique tempora fugit cupiditate.6"},{"name":"numquam7","displayName":"Quasi omnis reiciendis consequatur iste minima tempore.7"},{"name":"corrupti8","displayName":"Nobis fuga porro nostrum quas.8"},{"name":"numquam9","displayName":"Qui omnis quibusdam numquam explicabo consequuntur nihil corrupti molestias.9"}]</pre>
