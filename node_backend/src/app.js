require('dotenv').config();
const express = require('express');
const fileUpload = require('express-fileupload');
const app = express();
const port = process.env.PORT || 3000;
const routes = require('./routes');

app.use(express.json());
app.use(fileUpload({
     useTempFiles: true, // This option will store uploaded files in temporary directory
     tempFileDir: '/tmp/' // Temporary directory path
}));
app.use('/', routes);

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
