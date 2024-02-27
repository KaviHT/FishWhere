const axios = require('axios');
const FormData = require('form-data');
const fs = require('fs');

exports.getPredictions = async (req, res) => {
     if (!req.files || Object.keys(req.files).length === 0) {
          return res.status(400).send('No files were uploaded.');
      }
  
      // Access the uploaded file
      let file = req.files.file; // Use of middleware express-fileupload to parse files
  
      // Prepare the form data
      let formData = new FormData();
      formData.append('file', fs.createReadStream(file.tempFilePath)); // Adjust based on how you access the file
  
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
