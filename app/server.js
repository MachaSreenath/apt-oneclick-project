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
console.log(`Server running at http://${hostname}:${port}/`);
});
