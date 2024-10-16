import express from 'express';
import { createProxyMiddleware } from 'http-proxy-middleware';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const port = process.env.GATEWAY_PORT // Default to 3000 if not set

// Proxy for /movies
const inventoryProxy = createProxyMiddleware({
    target: process.env.GATEWAY_INVENTORY_URL,
    changeOrigin: true,
    logLevel: 'debug',
    onError: (err, req, res) => {
        console.error('Proxy Error (Inventory):', err.message, req.url);
        res.status(500).send(`Proxy Error (Inventory): ${err.message}`);
    }
});

// Proxy for /billing
console.log(process.env.GATEWAY_BILLING_URL);
const billingProxy = createProxyMiddleware({
    target: process.env.GATEWAY_BILLING_URL,
    changeOrigin: true,
    logLevel: 'debug',
    onError: (err, req, res) => {
        console.error('Proxy Error (Billing):', err);
        res.status(500).send('Proxy Error (Billing)');
    }
});

// Use the proxy middleware for all routes
app.use('/movies', inventoryProxy);
app.use('/billing', billingProxy);

app.listen(port, '0.0.0.0', () => {
    console.log(`Proxy server running at ${process.env.GATEWAY_URL}/`);
    console.log(`Proxying /movies requests to ${process.env.GATEWAY_INVENTORY_URL}`);
    console.log(`Proxying /billing requests to ${process.env.GATEWAY_BILLING_URL}`);
});