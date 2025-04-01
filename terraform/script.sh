#!/bin/bash

sudo yum install python python3-pip git nginx

cd ~

git clone https://github.com/StormyStack/photo-sharing-app.git

cd photo-sharing-app
cd app
pip install -r requirements.txt

sudo tee /etc/nginx/conf.d/photoapp.conf > /dev/null << 'EOL'
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOL

sudo rm -f /etc/nginx/default.d/default.conf
sudo nginx -t && sudo systemctl restart nginx

sudo tee /etc/systemd/system/photoapp.service > /dev/null << 'EOL'
[Unit]
Description=Flask App with Gunicorn
After=network.target

[Service]
User=ec2-user
Group=nginx
WorkingDirectory=/home/ec2-user/photo-sharing-app/app
Environment="PATH=/home/ec2-user/.local/bin"
ExecStart=/home/ec2-user/.local/bin/gunicorn -w 4 -b 0.0.0.0:8000 app:application
Restart=always

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl daemon-reload
sudo systemctl enable photoapp.service
sudo systemctl start photoapp.service

sudo nginx -t && sudo systemctl restart nginx
