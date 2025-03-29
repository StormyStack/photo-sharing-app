#!/bin/bash
set -e  # Exit on first error

echo "🔄 Updating system packages..."
sudo apt update -y && sudo apt upgrade -y

echo "📦 Installing required dependencies with retries..."
MAX_RETRIES=5
RETRY_DELAY=10  # Seconds between retries

install_packages() {
    local retries=0
    until sudo apt install -y python3-pip python3-venv git nginx; do
        retries=$((retries+1))
        if [ $retries -ge $MAX_RETRIES ]; then
            echo "❌ Package installation failed after $MAX_RETRIES attempts."
            exit 1
        fi
        echo "⚠️ Package installation failed. Retrying in $RETRY_DELAY seconds... ($retries/$MAX_RETRIES)"
        sleep $RETRY_DELAY
    done
}

install_packages

echo "📂 Setting up application directory..."
APP_DIR="/home/ubuntu/photo_share_app"
sudo mkdir -p $APP_DIR
sudo chown ubuntu:ubuntu $APP_DIR

if [ ! -d "$APP_DIR/.git" ]; then
    echo "📥 Cloning repository..."
    git clone https://github.com/StormyStack/photo-sharing-app.git $APP_DIR
else
    echo "✅ Repository already exists, skipping clone."
fi

echo "🐍 Setting up Python environment..."
cd $APP_DIR/app
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip

echo "📜 Installing Python dependencies with retries..."
install_python_packages() {
    local retries=0
    until pip install -r requirements.txt; do
        retries=$((retries+1))
        if [ $retries -ge $MAX_RETRIES ]; then
            echo "❌ Python dependency installation failed after $MAX_RETRIES attempts."
            exit 1
        fi
        echo "⚠️ Python dependency installation failed. Retrying in $RETRY_DELAY seconds... ($retries/$MAX_RETRIES)"
        sleep $RETRY_DELAY
    done
}

install_python_packages

echo "🚀 Configuring Gunicorn..."
sudo tee /etc/systemd/system/photoapp.service > /dev/null << 'EOL'
[Unit]
Description=Flask App with Gunicorn
After=network.target

[Service]
User=ubuntu
Group=www-data
WorkingDirectory=/home/ubuntu/photo_share_app/app
Environment="PATH=/home/ubuntu/photo_share_app/app/venv/bin"
ExecStart=/home/ubuntu/photo_share_app/app/venv/bin/gunicorn -w 3 -b 127.0.0.1:8000 app:app
Restart=always

[Install]
WantedBy=multi-user.target
EOL

echo "🌐 Configuring Nginx..."
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

echo "🔄 Restarting services..."
sudo systemctl daemon-reload
sudo systemctl enable photoapp.service
sudo systemctl restart photoapp.service
sudo systemctl restart nginx

echo "✅ Deployment complete! Your Flask app is running."
