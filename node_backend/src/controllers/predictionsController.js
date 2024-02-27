const axios = require('axios');
const FormData = require('form-data');
const fs = require('fs');

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
