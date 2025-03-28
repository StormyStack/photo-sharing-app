#!/bin/bash
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y python3-pip python3-venv git nginx

APP_DIR="/home/ubuntu/photo_share_app"
sudo mkdir -p $APP_DIR
sudo chown ubuntu:ubuntu $APP_DIR

if [ ! -d "$APP_DIR/.git" ]; then
    git clone https://github.com/StormyStack/photo-sharing-app.git $APP_DIR
else
    echo "Repository already cloned. Skipping..."
fi

cd $APP_DIR
cd app
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

if ! command -v gunicorn &> /dev/null; then
    echo "Gunicorn not found! Installing..."
    pip install gunicorn
fi


sudo tee /etc/nginx/sites-available/photoapp > /dev/null << 'EOL'
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

sudo ln -sf /etc/nginx/sites-available/photoapp /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default


sudo tee /etc/systemd/system/photoapp.service > /dev/null << 'EOL'
[Unit]
Description=Flask App with Gunicorn
After=network.target

[Service]
User=ubuntu
Group=www-data
WorkingDirectory=/home/ubuntu/photo_share_app
Environment="PATH=/home/ubuntu/photo_share_app/venv/bin"
ExecStart=/home/ubuntu/photo_share_app/venv/bin/gunicorn -w 3 -b 127.0.0.1:8000 app:app
Restart=always

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl daemon-reload
sudo systemctl enable photoapp.service
sudo systemctl restart photoapp.service

sudo nginx -t && sudo systemctl restart nginx

echo "✅ Deployment complete! Your Flask app is running."
