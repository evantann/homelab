require('dotenv').config();
const mysql = require('mysql');

// MySQL connection
const db = mysql.createConnection({
    host: 'mysql',
    user: 'root',
    password: process.env.DB_PASSWORD,
    database: 'items_db'
});

db.connect(err => {
    if (err) {
        console.error('Error connecting to database:', err);
        return;
    }
    console.log('Connected to MySQL database');
});

module.exports = db;