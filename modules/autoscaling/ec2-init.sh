#!/bin/bash
sudo apt-get update
sudo apt-get install nginx
ip=$(hostname -I)
echo "<html><body><h1>Hello from $ip</h1></body></html>" | sudo tee /var/www/html/index.html > /dev/null
sudo systemctl status nginx 