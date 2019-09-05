sudo apt-get update

# Install packages to allow apt to use a repository over HTTPS:
sudo apt-get -y install apt-transport-https
sudo apt-get -y install ca-certificates
sudo apt-get -y install curl
sudo apt-get -y install gnupg-agent
sudo apt-get -y install software-properties-common

# Install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# todo
#sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker

# Manage docker as a non-root user
sudo groupadd docker
sudo usermod -aG docker vagrant

# Install docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install bash completion
# Need for auto completion for docker
sudo apt-get -y install bash-completion

# Autocomplete for docker
sudo curl -L https://raw.githubusercontent.com/docker/compose/1.24.1/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
