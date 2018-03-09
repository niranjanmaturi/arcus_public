sudo apt-get update

sudo apt-get install -y \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

cat >/etc/docker/daemon.json <<EOL
{
  "hosts": [ "tcp://0.0.0.0:2375" ]
}
EOL

sudo apt-get update
sudo apt-get install -y docker-ce
