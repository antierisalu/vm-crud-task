import pkg from 'pg';
const { Pool } = pkg;


const pool = new Pool({
  user: process.env.BILLING_DB_USER,
  host: 'localhost',
  database: process.env.BILLING_DB_NAME,
  password: process.env.BILLING_DB_PASSWORD,
  port: process.env.BILLING_DB_PORT,
});


export async function saveOrderToDatabase(order) {
  const { user_id, number_of_items, total_amount } = order;

  try {
    const insertQuery = `
      INSERT INTO public.orders (user_id, number_of_items, total_amount)
      VALUES ($1, $2, $3) RETURNING id;
    `;

    const result = await pool.query(insertQuery, [user_id, number_of_items, total_amount]);
    console.log('Order saved with ID:', result.rows[0].id);
  } catch (error) {
    console.error('Error in database operation:', error);
    throw error;
  }
}

export async function ensureOrdersTableExists() {
    try {
      const createTableQuery = `
        CREATE TABLE IF NOT EXISTS public.orders (
          id SERIAL PRIMARY KEY,
          user_id INTEGER NOT NULL,
          number_of_items INTEGER NOT NULL,
          total_amount NUMERIC(10, 2) NOT NULL
        );
      `;
      await pool.query(createTableQuery);
      console.log('Orders table created or already exists');
  
      const tableStructureQuery = `
        SELECT column_name, data_type 
        FROM information_schema.columns 
        WHERE table_name = 'orders';
      `;
      const tableStructure = await pool.query(tableStructureQuery);
      console.log('Orders table structure:', tableStructure.rows);
  
      return true;
    } catch (error) {
      console.error('Error creating or checking orders table:', error);
      return false;
    }
  }
