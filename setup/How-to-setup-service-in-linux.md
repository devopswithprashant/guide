
# Setup a Service in Linux

In production, you generally don't want people to SSH into an EC2 instance and manually run:

```bash
cd /my-dir
sh artifact.sh start
```

Instead, you register the application as a Linux service and manage it using:

```bash
sudo systemctl start myapp
sudo systemctl stop myapp
sudo systemctl restart myapp
sudo systemctl status myapp
```

And if you enable it:

```bash
sudo systemctl enable myapp
```

it will automatically start whenever the EC2 instance boots.

---

## Typical Production Layout

Let's assume:

```
/opt/myapp/
├── app.jar
├── logs/
└── config/
```

And a dedicated user:

```bash
sudo useradd -r -s /bin/false myapp
```

---

## Create a Systemd Service

Create the service file:

```bash
sudo vi /etc/systemd/system/myapp.service
```

**Example:**

```ini
[Unit]
Description=Spring Boot Application
After=network.target

[Service]
Type=simple
User=myapp
Group=myapp
WorkingDirectory=/opt/myapp
ExecStart=/usr/bin/java -jar /opt/myapp/app.jar
SuccessExitStatus=143
Restart=always
RestartSec=10
StandardOutput=append:/opt/myapp/logs/app.log
StandardError=append:/opt/myapp/logs/error.log

[Install]
WantedBy=multi-user.target
```

---

## Reload Systemd

Whenever a new service file is added:

```bash
sudo systemctl daemon-reload
```

---

## Start Service

```bash
sudo systemctl start myapp
```

**Check status:**

```bash
sudo systemctl status myapp
```

---

## Enable Auto Start

This is the important part for EC2 reboot/startup:

```bash
sudo systemctl enable myapp
```

**Auto-start flow:**

```
EC2 Start
    ↓
Linux Boot
    ↓
systemd starts
    ↓
myapp.service starts automatically
```

No manual intervention needed.

---

## Stop / Restart

```bash
sudo systemctl stop myapp
sudo systemctl restart myapp
```

---

## View Logs

If you're using **Spring Boot**, I usually recommend sending logs to `journald` instead of managing log files yourself.

**Service file:**

```ini
StandardOutput=journal
StandardError=journal
```

**Then:**

```bash
journalctl -u myapp -f
```

**Live log streaming:**

```bash
journalctl -u myapp -f
```

**Last 100 lines:**

```bash
journalctl -u myapp -n 100
```

⸻

Using Your Existing Script

If your existing script already handles start/stop logic:

/opt/myapp/artifact.sh start
/opt/myapp/artifact.sh stop

then systemd can invoke the script directly:

[Service]
Type=forking
ExecStart=/opt/myapp/artifact.sh start
ExecStop=/opt/myapp/artifact.sh stop
User=myapp
Restart=always

However, for Spring Boot applications, it’s generally cleaner to let systemd launch the JAR directly rather than wrapping it in another script.

⸻

CI/CD Deployment Flow

A common deployment pipeline looks like:

```
GitLab Pipeline
       ↓
Build JAR
       ↓
Copy JAR to EC2
       ↓
sudo systemctl stop myapp
       ↓
Replace app.jar
       ↓
sudo systemctl start myapp
       ↓
Health Check
```

Or simply:

```bash
sudo systemctl restart myapp
```

after copying the new JAR.

---

## What Happens When EC2 Stops?

Suppose:

```bash
sudo systemctl enable myapp
```

has already been executed.

**Then:**

```
EC2 Stop
   ↓
Application stops
   ↓
EC2 Start
   ↓
Linux boots
   ↓
systemd starts
   ↓
myapp.service starts automatically
   ↓
Spring Boot application becomes available
```

**No user-data script is required for this.** Systemd is the standard and recommended approach for running Spring Boot applications as services on EC2.




---

## Example: Systemd Service File for Artifactory

If your current manual startup process is:

```bash
cd /opt/artifactory-oss-7.9.2/app/bin/
./artifactory.sh start
```

Then you can create a systemd service like this:

**File:** `/etc/systemd/system/artifactory.service`

```ini
[Unit]
Description=JFrog Artifactory OSS
After=network.target

[Service]
Type=forking
User=root
Group=root
WorkingDirectory=/opt/artifactory-oss-7.9.2/app/bin
ExecStart=/opt/artifactory-oss-7.9.2/app/bin/artifactory.sh start
ExecStop=/opt/artifactory-oss-7.9.2/app/bin/artifactory.sh stop
Restart=on-failure
RestartSec=30
TimeoutStartSec=300
TimeoutStopSec=300

[Install]
WantedBy=multi-user.target
```

### Step 1: Create the service

```bash
sudo vi /etc/systemd/system/artifactory.service
```

Paste the above content.

### Step 2: Reload systemd

```bash
sudo systemctl daemon-reload
```

### Step 3: Enable automatic startup on boot

```bash
sudo systemctl enable artifactory
```

### Step 4: Start the service

```bash
sudo systemctl start artifactory
```

### Step 5: Check status

```bash
sudo systemctl status artifactory
```

### Step 6: View logs

```bash
journalctl -u artifactory -f
```

### Step 7: Verify auto-start configuration

```bash
systemctl is-enabled artifactory
```

**Expected output:**

```
enabled
```

---

## ⚠️ Important: Verify Before Creating a Custom Service

**Artifactory 7.x** installations often already include service scripts under:

```
/opt/artifactory-oss-7.9.2/app/bin/installService.sh
```

or

```
/opt/jfrog/artifactory/app/bin/installService.sh
```

**Before creating a custom service, check:**

```bash
find /opt/artifactory-oss-7.9.2 -name "*Service*.sh"
```

and

```bash
ls -l /opt/artifactory-oss-7.9.2/app/bin/
```

If an official `installService.sh` exists, it's **usually preferable** because it creates a **vendor-supported systemd service** with the correct PID handling and startup dependencies.
