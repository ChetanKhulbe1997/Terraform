#!/bin/bash

sudo apt-get update
sudo apt-get install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

echo "<h1> Prasad Vitran by MKR </h1>" | sudo tee /var/www/html/index.html    # Or use "> /var/www/html/index.html"
