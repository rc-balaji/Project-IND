const express = require('express');
const router = express.Router();
const patientController = require('../controllers/patientController.js');

router.post('/signup/new', patientController.createPatient);

router.get('/patients', patientController.getPatients);
router.get('/patient/:username', patientController.getPatientByUsername);
router.post('/login', patientController.authenticatePatient);

router.put('/patients/:username', patientController.updatePatientProfile);


router.get('/patients/:username/journey-status', patientController.getJourneyStatus);
router.put('/patients/:username/journey-status', patientController.updateJourneyStatus);


router.put('/patients/:username/foods/:food', patientController.updateFoodItems);


module.exports = router;
