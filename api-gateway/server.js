import { createServer } from 'http';

const hostname = '0.0.0.0'; // Listen on all interfaces
const port = process.env.GATEWAY_PORT;

let requestCount = 0;

const server = createServer((req, res) => {

    requestCount++;
    const timestamp = new Date().toISOString();
    
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end(`Request #${requestCount} at ${timestamp}\nGATEWAY_MSG: ${process.env.GATEWAY_MSG}`);
});

server.listen(port, hostname, () => {
    console.log(`Server running at http://${hostname}:${port}/`);
});