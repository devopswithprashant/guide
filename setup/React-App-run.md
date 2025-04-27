
# Run a React App in EC2 (remote) server


1. Install Nginx in the EC2 (remote) server.

2. Make sure you prepare the build folder of your React-App
```sh
npm run build
```   
    
3. Use Basic scp Command to copy build folder into the remote server location
```sh
scp -r -i /path/to/your/private_key ./build/ username@remote_host:/remote/path/
```



✅ Example

If you want to deploy to /var/www/html on a server my-ec2-instance.amazonaws.com, using user ubuntu, and your key is ~/.ssh/my-aws-key.pem:
```sh
scp -r -i ~/.ssh/my-aws-key.pem ./build/ ubuntu@my-ec2-instance.amazonaws.com:/var/www/html
```
✅ That will copy everything in your local build/ folder to the remote server’s web root.

⸻

🛠️ Optional: Delete Old Build on Remote First

If you want to clear out the old content before copying the new build:

ssh -i ~/.ssh/my-aws-key.pem ubuntu@my-ec2-instance.amazonaws.com 'rm -rf /var/www/html/*'
scp -r -i ~/.ssh/my-aws-key.pem ./build/ ubuntu@my-ec2-instance.amazonaws.com:/var/www/html










