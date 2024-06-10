const Patient = require('../models/patient.js');

exports.createPatient = async (req, res) => {
  const { username, password } = req.body;
  const newPatient = new Patient({
    username,
    password,
    name: '',
    age: '',
    gender: '',
    maritalStatus: '',
    occupation: '',
    alcohol: false,
    smoke: false,
    journey: {
      registered_Date: new Date().toLocaleDateString(),
      records: []
    },
    patient_details: {
      height: 0,
      weight: 0,
      bp: '',
      waist_circumference: 0,
      fasting_blood_sugar: 0,
      ldl_cholesterol: 0,
      hdl_cholesterol: 0,
      triglyceride: 0,
      medication_list: []
    }
  });

  try {
    await newPatient.save();
    res.status(201).send(newPatient);
  } catch (error) {
    res.status(500).send(error);
  }
};

exports.updatePatient = async (req, res) => {
  const { username } = req.params;
  const updateData = req.body;

  try {
    // Find the patient by username
    let patient = await Patient.findOne({ username });
    if (!patient) {
      return res.status(404).send({ message: 'Patient not found' });
    }

    // Update the patient's details
    patient.set(updateData);

    // Ensure the registered_Date is updated if provided
    if (updateData.journey && updateData.journey.registered_Date) {
      patient.journey.registered_Date = updateData.journey.registered_Date;
    }

    // Save the updated patient
    await patient.save();
    
    res.status(200).send(patient);
  } catch (error) {
    res.status(500).send(error);
  }
};



exports.authenticatePatient = async (req, res) => {
  const { username, password } = req.body;

  try {
    const patient = await Patient.findOne({ username });
    if (!patient || patient.password !== password) {
      return res.status(401).send({ message: 'Wrong username or password' });
    }
    res.status(200).send({
      username: patient.username,
      name: patient.name,
      age: patient.age,
      gender: patient.gender,
      maritalStatus: patient.maritalStatus,
      occupation: patient.occupation,
      alcohol: patient.alcohol,
      smoke: patient.smoke
    });
  } catch (error) {
    res.status(500).send(error);
  }
};

exports.getPatients = async (req, res) => {
  try {
    const patients = await Patient.find();
    res.status(200).send(patients);
  } catch (error) {
    res.status(500).send(error);
  }
};

exports.getPatientByUsername = async (req, res) => {
  const { username } = req.params;
  try {
    const patient = await Patient.findOne({ username });
    if (patient) {
      res.status(200).send(patient);
    } else {
      res.status(404).send({ message: 'Patient not found' });
    }
  } catch (error) {
    res.status(500).send(error);
  }
};
