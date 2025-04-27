
# Install Java on Ubuntu EC2 Instances.

> install Java 17 on an Ubuntu EC2 instance.


1. Connect to your Ubuntu EC2 Instance
```sh
ssh -i your-key.pem ubuntu@your-ec2-public-ip
```
⸻

2. Install Java 17

First, update your packages:
```sh
sudo apt update
sudo apt upgrade -y
```
Then install Java 17 (from the default Ubuntu repositories or from ppa:openjdk-r):
```sh
sudo apt install openjdk-17-jdk -y
```
Check if Java installed correctly:
```sh
java -version
```
✅ You should see something like:
openjdk version "17.x.x"

