const axios = require('axios');
const FormData = require('form-data');
const fs = require('fs');
const path = require('path');

exports.getPredictions = async (req, res) => {
    if (!req.file) {
        return res.status(400).send('No file uploaded.');
    }

    // Prepare the form data with the file
    const formData = new FormData();

    // Ensure the file buffer and original name are present

    const fileStream = fs.createReadStream(req.file.path);
    formData.append('file', fileStream, req.file.originalname);

    try {
        const response = await axios.post(process.env.FLASK_SERVICE_URL, formData, {
            headers: {
                ...formData.getHeaders(),
            },
        });
        res.json(response.data);
    } catch (error) {
        console.error(error);
        res.status(500).send("Error getting predictions");
    }
};

exports.processFileByName = async (req, res) => {
    const { fileName } = req.body; // Expecting the filename to be sent in the request body

    if (!fileName) {
        return res.status(400).send('No file name provided.');
    }

    const filePath = path.join(__dirname, '../../../model_service/inputs', fileName);
    if (!fs.existsSync(filePath)) {
        return res.status(404).send('File not found.');
    }

    const formData = new FormData();
    const fileStream = fs.createReadStream(filePath);
    formData.append('file', fileStream, fileName);

    try {
        const response = await axios.post(process.env.FLASK_SERVICE_URL, formData, {
            headers: {
                ...formData.getHeaders(),
            },
        });
        res.json(response.data);
    } catch (error) {
        console.error(error);
        res.status(500).send("Error processing file");
    }
};

