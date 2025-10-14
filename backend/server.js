import dotenv from 'dotenv';
dotenv.config();

import express from 'express';
import mongoose from 'mongoose';
import cors from 'cors';
import petsRouter from './routes/pets.js';

const app = express();

// Enable CORS
app.use(cors({ origin: true, credentials: true }));

// Middleware to parse JSON
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Connect to MongoDB
mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
    .then(() => console.log('MongoDB Connected'))
    .catch((error) => console.error('MongoDB connection error:', error));

// Use pets routes
app.use('/pets', petsRouter);

// Start server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log('Server running on', PORT);
});
