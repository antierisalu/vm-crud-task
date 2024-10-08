// Import required libraries
import express, { json } from 'express';
import { connect } from 'amqplib';
import pkg from 'pg';
const { Pool } = pkg;

import dotenv from 'dotenv';
dotenv.config({ path: '../.env' });

// Set up Express app
const app = express();
const port = process.env.BILLING_PORT

// Middleware to parse JSON requests
app.use(json());

// Set up the PostgreSQL connection pool
const pool = new Pool({
  user: 'rabbit',       // PostgreSQL user
  host: 'localhost',      // Hostname where PostgreSQL is running
  database: 'orders',     // Database name
  password: 'rabbit',   // Password for the user
  port: 5432,             // PostgreSQL port
});

// Function to save the order to PostgreSQL
async function saveOrderToDatabase(order) {
  const { user_id, number_of_items, total_amount } = order;

  const query = `
    INSERT INTO orders (user_id, number_of_items, total_amount)
    VALUES ($1, $2, $3) RETURNING id;
  `;

  try {
    const result = await pool.query(query, [user_id, number_of_items, total_amount]);
    console.log('Order saved with ID:', result.rows[0].id);
  } catch (error) {
    console.error('Error inserting into database:', error);
  }
}

// Function to consume messages from RabbitMQ
async function consumeMessages() {
  try {
    const conn = await connect('amqp://localhost'); // Connect to RabbitMQ
    const channel = await conn.createChannel();

    const queue = 'orders_queue';  // Define the queue name

    await channel.assertQueue(queue, {
      durable: true  // Ensure the queue survives server restarts
    });

    console.log(`Waiting for messages in ${queue}. To exit press CTRL+C`);

    // Consume messages from the queue
    channel.consume(queue, async (msg) => {
      if (msg !== null) {
        const orderData = JSON.parse(msg.content.toString());

        // Process the order
        console.log('Received:', orderData);

        // Save order to PostgreSQL
        await saveOrderToDatabase(orderData);

        // Acknowledge message has been processed
        channel.ack(msg);
      }
    }, {
      noAck: false  // Manual message acknowledgment
    });

  } catch (error) {
    console.error('Error in RabbitMQ consumer:', error);
  }
}

// API endpoint to send messages to RabbitMQ
app.post('/orders', async (req, res) => {
  const order = req.body;

  try {
    const conn = await connect('amqp://localhost');
    const channel = await conn.createChannel();
    const queue = 'orders_queue';

    // Send the order to the RabbitMQ queue
    await channel.assertQueue(queue, { durable: true });
    channel.sendToQueue(queue, Buffer.from(JSON.stringify(order)), { persistent: true });

    console.log('Sent to RabbitMQ:', order);
    res.status(200).send('Order received and sent to queue.');
  } catch (error) {
    console.error('Error sending to RabbitMQ:', error);
    res.status(500).send('Error processing order');
  }
});

// Start consuming messages
consumeMessages();

// Start the Express server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
