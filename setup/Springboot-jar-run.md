
# Run springboot jar in ec2

> Set up for running a Spring Boot JAR file on an Ubuntu EC2 instance.

1. Transfer Your Spring Boot JAR File

From your local machine to EC2 (example command):
```sh
scp -i your-key.pem path-to-your-backend.jar ubuntu@your-ec2-public-ip:/home/ubuntu/
```
Or you can use wget inside the EC2 if the JAR is hosted somewhere.


2. Run the JAR File

Navigate to the directory where your JAR is:
```sh
cd /home/ubuntu/
```
Run the Spring Boot application:
```sh
java -jar your-backend.jar
```
✅ If it starts successfully, you’ll see logs like:
Started Application in X.XXX seconds

⸻

3. (Optional) Run it in Background

If you want the Spring Boot app to keep running after you close the terminal, use:
```sh
nohup java -jar your-backend.jar > output.log 2>&1 &
```
  1. nohup = no hangup (keeps running)
  2. > output.log = saves logs to file
  3. & = run in background

Check if it’s running:
```sh
ps aux | grep java
```


4. (Optional) Open Port if Needed

If your Spring Boot app runs on a custom port (like 8080), make sure your EC2 Security Group allows inbound access to that port.

Go to AWS Console → EC2 → Security Groups → Inbound Rules → Add Rule:
	•	Type: Custom TCP
	•	Port Range: 8080 (or whatever your app uses)
	•	Source: 0.0.0.0/0 (or restrict as per your need)




## How to Stop running springboot jar


When you run:
```sh
nohup java -jar your-backend.jar > output.log 2>&1 &
```
the shell will immediately output the PID (Process ID) of the background process like this:
```
[1] 12345
```
where 12345 is the PID.



Ways to Track and Kill the Process:

Option 1: Save PID when starting

Modify your nohup command slightly to save the PID to a file:
```sh
nohup java -jar your-backend.jar > output.log 2>&1 & echo $! > app.pid
```
  1.	$! = gives you the PID of the last background process
  2.	app.pid = file where the PID is saved

✅ Later, if you want to stop the app, you can kill it like:
```sh
kill $(cat app.pid)
```
and if you want to force kill (if normal kill doesn’t work):
```sh
kill -9 $(cat app.pid)
```


⸻

Option 2: Search for running Java processes

If you forgot to save the PID:
```sh
ps aux | grep java
```
You’ll see output like:
```
ubuntu   12345  0.2  2.3 1234567 23456 ?  Sl   12:00   0:05 java -jar your-backend.jar
```
Here, 12345 is the PID you can manually kill:
```sh
kill 12345
```


⸻

Summary:

Action	Command
Start app and save PID	nohup java -jar your-backend.jar > output.log 2>&1 & echo $! > app.pid
Kill app using PID	kill $(cat app.pid)
Check if still running	`ps aux

