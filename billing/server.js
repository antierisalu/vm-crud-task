import express from 'express';
import { connect } from 'amqplib';
import dotenv from 'dotenv';
import { ensureOrdersTableExists } from './database.js';

dotenv.config({ path: '../.env' });

const app = express();
const port = process.env.BILLING_PORT || 5000;

app.use(express.json());

// Ensure the orders table exists when the server starts
ensureOrdersTableExists();

app.post('/orders', async (req, res) => {
  const order = req.body;
  console.log('Received order:', order);

  try {
    const conn = await connect(`amqp://${process.env.RABBITMQ_HOST}`);
    const channel = await conn.createChannel();
    const queue = 'orders_queue';

    await channel.assertQueue(queue, { durable: true });
    channel.sendToQueue(queue, Buffer.from(JSON.stringify(order)), { persistent: true });

    console.log('Sent to RabbitMQ:', order);
    res.status(200).send('Order received and sent to queue.');
  } catch (error) {
    console.error('Error sending to RabbitMQ:', error);
    // Still return success to the client
    res.status(200).send('Order received.');
  }
});

app.listen(port, () => {
  console.log(`Server is running on http://${process.env.BILLING_DB_HOST}:${port}`);
});