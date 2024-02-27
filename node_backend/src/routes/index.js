const express = require('express');
const router = express.Router();
const predictionsController = require('../controllers/predictionsController');

router.post('/predict', predictionsController.getPredictions);

module.exports = router;
