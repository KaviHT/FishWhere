require('dotenv').config();
const express = require('express');
const cors = require('cors');
const app = express();
const PORT = process.env.PORT || 3000;
const routes = require('./routes');

const mongoose = require('mongoose');
mongoose.connect('mongodb://localhost/fishWhereDB', { useNewUrlParser: true, useUnifiedTopology: true });

app.use(express.json());
app.use(cors());
app.use('/', routes);

app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});
