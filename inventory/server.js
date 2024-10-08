import express from 'express';
import { json, urlencoded } from 'body-parser';
import { Sequelize, DataTypes } from 'sequelize';
import dotenv from 'dotenv';
dotenv.config();

const app = express();
const port = process.env.INVENTORY_PORT;

// Middleware
app.use(json());
app.use(urlencoded({ extended: true }));


// Database connection
const sequelize = new Sequelize(
  process.env.INVENTORY_DB_NAME,
  process.env.INVENTORY_DB_USER,
  process.env.INVENTORY_DB_PASSWORD,
  {
    host: process.env.INVENTORY_DB_HOST,
    port: process.env.INVENTORY_DB_PORT,
    dialect: 'postgres'
  }
);

// Define Movie model
const Movie = sequelize.define('Movie', {
  title: {
    type: DataTypes.STRING,
    allowNull: false
  },
  description: {
    type: DataTypes.TEXT,
    allowNull: true
  }
});

// Sync database
sequelize.sync({ force: true })
  .then(() => {
    console.log('Database & tables created!');
  });

// Routes
// GET all movies
app.get('/api/movies', async (req, res) => {
  try {
    const { title } = req.query;
    let movies;
    if (title) {
      movies = await Movie.findAll({ where: { title: { [Sequelize.Op.iLike]: `%${title}%` } } });
    } else {
      movies = await Movie.findAll();
    }
    res.json(movies);
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving movies', error });
  }
});

// POST new movie
app.post('/api/movies', async (req, res) => {
  try {
    const movie = await Movie.create(req.body);
    res.status(201).json(movie);
  } catch (error) {
    res.status(400).json({ message: 'Error creating movie', error });
  }
});

// DELETE all movies
app.delete('/api/movies', async (req, res) => {
  try {
    await Movie.destroy({ where: {} });
    res.status(204).send();
  } catch (error) {
    res.status(500).json({ message: 'Error deleting movies', error });
  }
});

// GET movie by id
app.get('/api/movies/:id', async (req, res) => {
  try {
    const movie = await Movie.findByPk(req.params.id);
    if (movie) {
      res.json(movie);
    } else {
      res.status(404).json({ message: 'Movie not found' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving movie', error });
  }
});

// PUT update movie
app.put('/api/movies/:id', async (req, res) => {
  try {
    const movie = await Movie.findByPk(req.params.id);
    if (movie) {
      await movie.update(req.body);
      res.json(movie);
    } else {
      res.status(404).json({ message: 'Movie not found' });
    }
  } catch (error) {
    res.status(400).json({ message: 'Error updating movie', error });
  }
});

// DELETE movie by id
app.delete('/api/movies/:id', async (req, res) => {
  try {
    const movie = await Movie.findByPk(req.params.id);
    if (movie) {
      await movie.destroy();
      res.status(204).send();
    } else {
      res.status(404).json({ message: 'Movie not found' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Error deleting movie', error });
  }
});

// Start server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
