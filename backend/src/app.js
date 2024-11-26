const cors = require('cors');
const dotenv = require('dotenv');
const express = require('express');
const morgan = require('morgan');
const { errorHandler } = require('./middleware/errorHandler');

/*
Import routes here:
*/
const authRoutes = require('./routes/auth.routes');

dotenv.config();

const app = express();
app.set('trust proxy', true);

app.use(morgan('tiny'));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.get('/', (req, res) => res.send('Hello from MealPrep!'));
app.get('/api', (req, res) => res.send('Hello from MealPrep API!'));
app.use('/api', authRoutes);

// Error Handling Middleware
app.use(errorHandler);

// Catch-all 404 for undefined routes
app.use((req, res, next) => {
  res.status(404).json({
    status: 0,
    message: 'Not Found - The requested resource does not exist.',
  });
});

module.exports = app;