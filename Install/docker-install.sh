# Docker Install script for debian/ubuntu 

# Update packages
sudo apt update

# Install dependencies
sudo apt install -y ca-certificates curl

# Add Docker’s official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Provide read write permission to all user, it can be avoid in some cases, but it's recommended if you faces any permission related issue
sudo chmod 666 /var/run/docker.sock

# Start & Enable Docker to start on boot
sudo systemctl start docker
sudo systemctl enable docker

# Verify Docker is running
sudo systemctl status docker

# Check Docker version
docker --version

# Test Docker with a sample container
sudo docker run hello-world




