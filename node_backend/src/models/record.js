const mongoose = require('mongoose');

const recordSchema = new mongoose.Schema({
  date: { type: Date, required: true },
  lon: { type: Number, required: true },
  lat: { type: Number, required: true },
  weight: { type: Number, required: true }
});

module.exports = mongoose.model('Record', recordSchema);
