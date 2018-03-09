# How to Install Arcus

## Requirements

* OS with BASH installed.
* Docker v1.12.0 or higher installed and accessible to the user running the installer.
* If using SSL, the cert chain and key in PEM format.

## Installation

1. Unzip the provided arcus.zip file to the directory of your choosing.
2. Set environment variables to override the default values, if desired:
    * PRODUCTION_PASSWORD - Used to set the mysql DB password
      * (Default: randomly generated hex value)
    * MYSQL_DATA_DIR - The location Arcus should store the MySQL database files
      * (Default: /opt/arcus/data)
    * ARCUS_CERT_DIR - If using SSL, the directory of the cert and key
      * (Default: /opt/arcus/certs)
    * ARCUS_CERT_KEY - If using SSL, the name of the key file, relative to the directory ARCUS_CERT_DIR
      * (Default: ssl.key)
    * ARCUS_CERT_FILE - If using SSL, the name of the cert chain file, relative to the directory ARCUS_CERT_DIR
      * (Default: ssl.cert)
    * ARCUS_HTTP_PORT - The port that Arcus should be available on via HTTP.
      * (Default: 80)
    * ARCUS_HTTPS_PORT - The port that Arcus should be available on via HTTPS (if using SSL).
      * (Default: 443)
3. Run the install.sh script in the extracted arcus directory.
    * If running the script as a non-root user, use `sudo -E ./install.sh`

## Getting Started
1. Navigate to the IP address or URL that you assigned to Arcus
2. Login with the default administrator account

**Note: It is strongly recommended that you create a new administrator account and then remove the default administrator account.**
