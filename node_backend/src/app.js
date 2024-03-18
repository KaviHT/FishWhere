require('dotenv').config();
const express = require('express');
const cors = require('cors');
const app = express();
const PORT = process.env.PORT || 3000;
const routes = require('./routes');

const mongoose = require('mongoose');

// Use the MONGODB_URI environment variable if it's set, otherwise default to your local MongoDB URI
const mongoURI = process.env.MONGODB_URI || 'mongodb://localhost/fishWhereDB';
mongoose.connect(mongoURI, { useNewUrlParser: true, useUnifiedTopology: true });

app.use(express.json());
app.use(cors());
app.use('/', routes);

app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});

module.exports = app;