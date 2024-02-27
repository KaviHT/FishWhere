const axios = require('axios');

exports.getPredictions = async (req, res) => {
    try {
        const response = await axios.post(process.env.FLASK_SERVICE_URL, req.body, {
            headers: {
                'Content-Type': 'multipart/form-data',
            },
        });
        res.json(response.data);
    } catch (error) {
        console.error(error);
        res.status(500).send("Error getting predictions");
    }
};
