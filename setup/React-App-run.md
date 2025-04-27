
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




------------

## Troubleshooting

### ** Need to update nginx sites-available conf if forntend is making api call to backend**

#### **1. Incorrect Server Block Configuration**
Check your site configuration:
```bash
sudo nano /etc/nginx/sites-available/your-site.conf
```

**Sample React App Configuration**:
```nginx
server {
    listen 80;
    server_name your-domain.com;

    root /var/www/your-frontend-build;
    index index.html;

    # Client-Side Routing (Critical Fix)
    location / {
        try_files $uri $uri/ /index.html;
    }

    # [OPTIONAL] API Proxy (if needed, this can be ignore if CORS setup in backend & doesn't need to proxy the api call)
    location /api {
        # Remote backend address (update with your actual IP/domain)
        proxy_pass http://your-remote-backend-ip:8080;
        
        # Essential headers for proper routing
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    
        # Timeouts (adjust based on backend response times)
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
        
        # Buffering settings
        proxy_buffering off;
        proxy_request_buffering off;
        
        # CORS headers (if backend doesn't handle them)
        add_header 'Access-Control-Allow-Origin' "$http_origin" always;
        add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS' always;
        add_header 'Access-Control-Allow-Headers' 'Authorization,Content-Type' always;
    }

    # [Recomended] Static Asset Caching
    location /static {
        expires 1y;
        add_header Cache-Control "public";
    }
}
```

#### **2. File Permissions**
Ensure Nginx has access:
```bash
sudo chown -R www-data:www-data /var/www
sudo chmod -R 755 /var/www
```

#### **3. Firewall Settings**
Allow HTTP/HTTPS traffic:
```bash
sudo ufw allow 'Nginx Full'
```

#### **4. SELinux Context (if enabled)**
```bash
sudo chcon -Rt httpd_sys_content_t /var/www
# OR temporarily disable SELinux
sudo setenforce 0
```

------------



### **Step-by-Step Solution**

1. **Reload systemd Daemon**
   ```bash
   sudo systemctl daemon-reload
   ```

2. **Restart Nginx**
   ```bash
   sudo systemctl restart nginx
   ```

3. **Check Nginx Status**
   ```bash
   sudo systemctl status nginx
   ```

4. **Verify Nginx Configuration**
   ```bash
   sudo nginx -t
   ```

---




### **Key Files to Verify**
| File/Permission | Command to Check |
|-----------------|------------------|
| Nginx Error Log | `sudo tail -f /var/log/nginx/error.log` |
| Access Log | `sudo tail -f /var/log/nginx/access.log` |
| Config Syntax | `sudo nginx -t` |
| Port Listening | `sudo ss -tulpn | grep nginx` |

---

### **Final Checks**
1. Ensure your React build files exist in the configured root directory
2. Verify domain DNS records point to your server IP
3. Test with curl:
   ```bash
   curl -I http://localhost
   ```


