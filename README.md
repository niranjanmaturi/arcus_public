# [Trello Board](https://trello.com/b/MvJyBWZz), <https://trello.com/b/MvJyBWZz>

# [Cisco CloudCenter Sandbox](https://c3-ccm-asl.sandbox.wwtatc.local/), <https://c3-ccm-asl.sandbox.wwtatc.local/>

- Email: admin@wwtatc.com
- Password: ASLasl1!
- Tenant ID: (blank)

# [gitlab docker executor](https://docs.gitlab.com/runner/executors/docker.html), <https://docs.gitlab.com/runner/executors/docker.html>

# Demo site
http://10.253.129.45/admin
- Email: admin@example.com
- Password: password1

# To enable HTTPS and MySQL TLS

* Run ```docker-compose -f docker-compose.yml -f docker-compose-ssl.yml  up --build```

# To enable C3 to make HTTPS requests to demo-arcus

- copy certs/demo-ca-cert.pem to the c3 machine
- run `keytool -import -alias wwt -keystore /usr/local/osmosix/ssl/ccm/ca_truststore.jks -file demo-ca-cert.pem` on the c3 machine
- keystore password is `osmosix`
- reboot the c3 machine
