#!/bin/bash -xe
# Runs on instance launch. Installs Node, writes app files, and starts the server on port 8080


apt update -y
apt install -y nodejs npm unzip curl


# create app dir
mkdir -p /home/ubuntu/app
chown -R ubuntu:ubuntu /home/ubuntu/app


cat > /home/ubuntu/app/server.js <<'EOF'
const http = require('http');
const hostname = '0.0.0.0';
const port = 8080;
const server = http.createServer((req, res) => {
if (req.url === '/') {
res.writeHead(200, { 'Content-Type': 'text/plain' });
res.end('Welcome to Private EC2 behind ALB');
} else if (req.url === '/health') {
res.writeHead(200, { 'Content-Type': 'text/plain' });
res.end('ok');
} else {
res.writeHead(404, { 'Content-Type': 'text/plain' });
res.end('Not Found');
}
});
server.listen(port, hostname, () => {
fconsole.log(`Server running on port 8080`);
});
EOF


cat > /home/ubuntu/app/package.json <<'EOF'
{
"name": "apt-private-api",
"version": "1.0.0",
"main": "server.js",
"scripts": { "start": "node server.js" }
}
EOF


cd /home/ubuntu/app
npm install --silent || true


# start server as ubuntu user
nohup node server.js > /home/ubuntu/app/app.log 2>&1 &


# send logs to cloudwatch (optional - minimal implementation skipped)


# mark finished
echo "User-data complete" >/home/ubuntu/user-data-complete.txt