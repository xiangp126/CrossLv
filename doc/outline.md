## Outline App

### Install Docker
```bash
# sudo yum remove docker
# sudo yum remove docker-common
curl -sS https://get.docker.com/ | sudo sh

sudo service docker start
```

### Deploy Outline
```bash
wget -qO- https://raw.githubusercontent.com/Jigsaw-Code/outline-server/master/src/server_manager/install_scripts/install_server.sh | sudo bash
```

Then copy `apiUrl` and `certSha256`