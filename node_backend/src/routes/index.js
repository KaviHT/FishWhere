const express = require('express');
const fs = require('fs');
const path = require('path');
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

router.post('/process-file', predictionsController.processFileByName);

router.get('/list-input-files', async (req, res) => {
    const inputDirPath = path.join(__dirname, '../../../model_service/inputs');
    fs.readdir(inputDirPath, (err, files) => {
        if (err) {
            console.error("Could not list the directory.", err);
            return res.status(500).send("Failed to list files");
        }
        const csvFiles = files.filter(file => file.endsWith('.csv'));
        res.json({ files: csvFiles });
    });
});

module.exports = router;
