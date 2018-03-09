# Results API

## GET devices/:device_id/templates/:template_id/results.:format - authorization happy paths - cookie auth - it returns the correct data

### GET devices/:device_id/templates/:template_id/results.:format
### Request

#### Headers

<pre>Authorization: Basic dGFtYXJhX2Zpc2hlcjo3dEkzUXowOE9tS3M2OUE=
Host: example.org
Cookie: </pre>

#### Route

<pre>GET devices/56/templates/52/results.c3</pre>

### Response

#### Headers

<pre>X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Content-Type: application/html; charset=utf-8
ETag: W/&quot;bf8d4fe886183577dee13e949ce91531&quot;
Cache-Control: max-age=0, private, must-revalidate
Set-Cookie: _arcus-service_session=aElreGJldXliVjVYcHlKbjVvcXRuVGZ6UHZPZG1UMVBwS0tMdGlEV3RwU2VGZGpMSkpYUGJhcFJqUk9IZDJyM1hBZFE5MElsMUZqZE9venRYQzkvNHc9PS0tZHNqUkhya1FTbm9tYkFaUmZxQ1dhZz09--e4212fb96310ef7810cfc9840caa5b6fcbc8612e; path=/; HttpOnly
X-Request-Id: 98404dfd-09a6-4d22-bcdf-4258bce7dad9
X-Runtime: 0.019996
Content-Length: 807</pre>

#### Status

<pre>200 OK</pre>

#### Body

<pre>[{"name":"ducimus0","displayName":"Provident quia aspernatur fugit reprehenderit laborum ad ut.0"},{"name":"hic1","displayName":"Non et vitae atque.1"},{"name":"sunt2","displayName":"Et deleniti qui incidunt occaecati fugit qui mollitia.2"},{"name":"qui3","displayName":"Et culpa ipsa voluptas voluptatem deleniti cumque libero.3"},{"name":"sint4","displayName":"Est omnis eligendi dolores.4"},{"name":"vitae5","displayName":"Assumenda eveniet rerum illum accusamus ducimus.5"},{"name":"esse6","displayName":"Ut ut ea est corporis iure commodi eligendi quos.6"},{"name":"sit7","displayName":"Adipisci atque totam voluptas laudantium esse sed aperiam molestiae.7"},{"name":"hic8","displayName":"Exercitationem dicta laudantium quas est.8"},{"name":"nemo9","displayName":"Molestiae hic voluptatem impedit.9"}]</pre>
