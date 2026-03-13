
#!/bin/bash
yum update -y
yum install nginx -y
systemctl enable nginx
systemctl start nginx
echo "Hello from Terraform" > /usr/share/nginx/html/index.html
