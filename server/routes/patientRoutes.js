const express = require('express');
const router = express.Router();
const patientController = require('../controllers/patientController.js');

router.post('/signup/new', patientController.createPatient);
router.put('/patients/:username', patientController.updatePatient);

router.get('/patients', patientController.getPatients);
router.get('/patient/:username', patientController.getPatientByUsername);
router.post('/login', patientController.authenticatePatient);

module.exports = router;
