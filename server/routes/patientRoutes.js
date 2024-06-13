const express = require('express');
const router = express.Router();
const patientController = require('../controllers/patientController.js');

router.post('/login', patientController.authenticatePatient);
router.get('/patients', patientController.getPatient);

router.get('/checkPatientId', patientController.checkPatientId);

router.put('/patients/:username', patientController.updatePatientProfile);

router.post('/signup/new', patientController.createPatient);

router.put('/patients/:username/foods/:food', patientController.updateFoodItems);

router.get('/patients/:username/journey-percentage', patientController.getJourneyPercentage);
router.put('/patients/:username/journey-percentage', patientController.updateJourneyPercentage);


router.post('/patients/:username/updateSmokeItems', patientController.updateSmokeItems);

router.post('/patients/:username/updateAlcoholItems',patientController.updateAlcoItems);
router.post('/patients/:username/updateWaterIntake',patientController.updateWaterItems);
router.post('/patients/:username/updateSleepingHabits',patientController.updateSleepItems);

router.post('/add-medication-list', patientController.addMedicationList);

router.post('/updatePatientDetails', patientController.updatePatientDetails);

module.exports = router;
