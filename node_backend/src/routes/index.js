const express = require('express');
const router = express.Router();
const multer = require('multer');
const predictionsController = require('../controllers/predictionsController');

// Configure multer for file uploads
const upload = multer({ dest: 'uploads/' });

router.post('/predict', upload.single('file'), predictionsController.getPredictions);

module.exports = router;
