const express = require('express');
const cors = require('cors');
const db = require('./db/connection');

const app = express();
const PORT = 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.get('/items', (req, res) => {
    db.query('SELECT * FROM items', (err, results) => {
        if (err) {
            console.error(err);
            res.status(500).send('Database error');
        } else {
            res.json(results);
        }
    });
});

app.post('/items', (req, res) => {
    const { name } = req.body;
    db.query('INSERT INTO items (name) VALUES (?)', [name], (err, results) => {
        if (err) {
            console.error(err);
            res.status(500).send('Database error');
        } else {
            res.status(201).json({ id: results.insertId, name });
        }
    });
});

// Start server
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});