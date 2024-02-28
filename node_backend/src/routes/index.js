const express = require('express');
const router = express.Router();
const multer = require('multer');
const predictionsController = require('../controllers/predictionsController');

const storage = multer.diskStorage({
     destination: function (req, file, cb) {
          cb(null, 'uploads/');
     },
     filename: function (req, file, cb) {
          cb(null, file.fieldname + '-' + Date.now());
     }
})

// Configure multer for file uploads
const upload = multer({ storage: storage});

router.post('/predict', upload.single('file'), predictionsController.getPredictions);

module.exports = router;
