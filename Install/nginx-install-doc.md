
# Install Nginx in Ubuntu or Amazon Linux 2


Here’s a quick guide to install Nginx and serve its default page on an EC2 instance running either Ubuntu or Amazon Linux 2 (AL2):

⸻

🚀 Step-by-Step Instructions

✅ 1. Connect to your EC2 instance
```
ssh -i your-key.pem ec2-user@your-ec2-public-ip
```
for Ubuntu:
```bash
ssh -i your-key.pem ubuntu@your-ec2-public-ip
```



⸻

✅ 2. Install Nginx

👉 On Ubuntu:

```bash
sudo apt update
sudo apt install -y nginx
```

👉 On Amazon Linux 2 (AL2):

```bash
sudo amazon-linux-extras enable nginx1
sudo yum install -y nginx
```


⸻

✅ 3. Start and Enable Nginx

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```


⸻

✅ 4. Allow HTTP (Port 80) in Security Group
	•	Go to EC2 Console → Instances → Security → Security Groups
	•	Edit Inbound Rules:
	•	Add Rule: HTTP, Port 80, Source: Anywhere (0.0.0.0/0)

⸻

✅ 5. Access the Default Page

Open your browser and go to:

http://<your-ec2-public-ip>

You should see the default Nginx welcome page 🎉

⸻

✅ 6. (Optional) Check Status

```bash
sudo systemctl status nginx
```


⸻

