const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');
const patientRoutes = require('./routes/patientRoutes.js');

const app = express();

mongoose.connect('mongodb+srv://rcbalaji:07070707@cluster0.bbw2v33.mongodb.net/Suruksha?retryWrites=true&w=majority&appName=Cluster0', {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(()=>{
    console.log("Mongo Connected");
}).catch((error)=>{
    console.error(error);
});

app.use(bodyParser.json());
app.use(cors());
app.use('/api', patientRoutes);

app.listen(3000, () => {
  console.log('Server is running on port 3000');
});
