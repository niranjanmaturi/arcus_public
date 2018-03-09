# Configuring C3

## Installing a trusted certificate authority

1. Copy the certificate file for the certificate authority to the C3 machine (e.g. arcus-ca-cert.pem)
1. Run `keytool -import -alias wwt -keystore /usr/local/osmosix/ssl/ccm/ca_truststore.jks -file arcus-ca-cert.pem` on the C3 machine
1. Keystore password is `osmosix`
1. Reboot the C3 machine
