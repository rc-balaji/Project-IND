const Patient = require('../models/patient');
const moment = require('moment');


var struct = (currentdate)=>{

  return {
    date: currentdate,
    status_percentage: 0,
    status: false,
    food: {},
    exercise: { status: false, actions: [] },
    sleeping_habits:  {
      status: false, // Assuming you want to send the status as true
      sleep_quality: "",
      undisturbed_sleep_hours: "",
      nap_duration: "",
    },
    water: {
      intake: 0,
    },
    alcohol: {
      consumedAlcoholToday: "",
      glassesConsumed: 0,
    },
    smoke: {
      consumed_smoke_today: "",
      cigarettes_consumed: 0,
    }
  };
}
exports.addMedicationList = async (req, res) => {
  console.log("Adding Medication List");
  try {
    const { patient_id, medication_list } = req.body;
    
    const patient = await Patient.findOne({ username: patient_id });

    if (!patient) {
      return res.status(404).json({ message: 'Patient not found' });
    }

    // Update medication_list field in the patient document
    patient.medication_list = medication_list;

    // Save the updated patient document
    await patient.save();

    res.status(200).json({ message: 'Medication list added successfully' });
  } catch (error) {
    console.error('Error adding medication list:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};


exports.updatePatientDetails = async (req, res) => {
  const { patientId } = req.body;
  const patientDetails = req.body.patient_details;

  try {
    const patient = await Patient.findOneAndUpdate(
      { username: patientId },
      { $set: { 'patient_details': {...patientDetails,medication_list:[]} } },
      { new: true }
    );

    if (patient) {
      res.status(200).json({ message: 'Patient details updated successfully', patient });
    } else {
      res.status(404).json({ message: 'Patient not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.checkPatientId = async (req, res) => {
  const { patientId } = req.query;
  try {
    const patient = await Patient.findOne({ username: patientId });
    if (patient) {
      res.json({ exists: true });
    } else {
      res.json({ exists: false });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
// Create a new patient

exports.getPatient = async (req, res) => {
  console.log("VVVVVVVVVVVVVVV");
  const { sortBy, username, date } = req.query;
  let sortCriteria = {};

  if (sortBy === 'username') {
    sortCriteria = { username: 1 };
  } else if (sortBy === 'date') {
    sortCriteria = { 'journey.registered_Date': -1 };
  }

  try {
    let patients;

    if (username) {
      patients = await Patient.find({ username }).exec();
    } else if (date) {
      patients = await Patient.find().exec();
      patients = patients.map(patient => ({
        username: patient.username,
        records: patient.journey.records.filter(record => record.date === date)
      }));
    } else {
      patients = await Patient.find().sort(sortCriteria).exec();
    }

    console.log(patients);
    res.json(patients);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};


exports.createPatient = async (req, res) => {
  const { username, password } = req.body;
  const newPatient = new Patient({
    username,
    password,
    name: '',
    age: null,
    gender: '',
    maritalStatus: '',
    occupation: '',
    alcohol: false,
    smoke: false,
    journey: {
      registered_Date: '', // To be set to the current date or kept empty as per requirements
      records: []
    },
    patient_details: {
      height: null,
      weight: null,
      bp: '',
      waist_circumference: null,
      fasting_blood_sugar: null,
      ldl_cholesterol: null,
      hdl_cholesterol: null,
      triglyceride: null,
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

// Update patient profile
exports.updatePatientProfile = async (req, res) => {
  const { username } = req.params;
  const { password, name, age, gender, maritalStatus, occupation, alcohol, smoke, journey } = req.body;

  try {
    const patient = await Patient.findOne({ username });

    if (!patient) {
      return res.status(404).send({ message: 'Patient not found' });
    }

    patient.password = password || patient.password;
    patient.name = name || patient.name;
    patient.age = age || patient.age;
    patient.gender = gender || patient.gender;
    patient.maritalStatus = maritalStatus || patient.maritalStatus;
    patient.occupation = occupation || patient.occupation;
    patient.alcohol = alcohol != null ? alcohol : patient.alcohol;
    patient.smoke = smoke != null ? smoke : patient.smoke;
    patient.journey.registered_Date = journey.registered_Date || patient.journey.registered_Date;

    await patient.save();

    res.status(200).send(patient);
  } catch (error) {
    res.status(500).send(error);
  }
};

// Authenticate patient
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

// Update food items
exports.updateFoodItems = async (req, res) => {
  const { username, food } = req.params;
  const foodItems = req.body;
  console.log("Gettttttt");
  try {
    const patient = await Patient.findOne({ username });
    if (!patient) {
      return res.status(404).send({ message: 'Patient not found' });
    }

    const currentDate = moment().format('DD/MM/YYYY');
    let todayRecord = patient.journey.records.find(record => record.date === currentDate);

    if (!todayRecord) {
      todayRecord = struct(currentDate);
      patient.journey.records.push(todayRecord);
      await patient.save();
    }
    console.log(todayRecord+"\n"+foodItems.food.Fruits);
    
    todayRecord = patient.journey.records.find(record => record.date === currentDate);
    console.log("sssssssssssssssssssssssssssssxsxsx");
    
    console.log(todayRecord);
    todayRecord.food[food] = foodItems.food[food];

    await patient.save();
    res.status(200).send(todayRecord);
  } catch (error) {
    res.status(500).send(error);
  }
};

// Update smoke items

exports.updateSmokeItems = async (req, res) => {
  const { username } = req.params;
  const smoke = req.body;

  console.log(smoke);

  try {
    const patient = await Patient.findOne({ username });
    if (!patient) {
      return res.status(404).send({ message: 'Patient not found' });
    }

    const currentDate = moment().format('DD/MM/YYYY');
    let todayRecord = patient.journey.records.find(record => record.date === currentDate);

    if (!todayRecord) {
      todayRecord = struct(currentDate)
      patient.journey.records.push(todayRecord);
    }

    console.log(todayRecord);
    
    todayRecord.smoke.consumed_smoke_today= smoke.consumed_smoke_today;
    todayRecord.smoke.cigarettes_consumed = smoke.cigarettes_consumed;

    console.log("sssssssssssssssssssssssssssssssssssssssssssssssss\n");
    console.log(todayRecord);

    await patient.save();
    res.status(200).send(todayRecord);
  } catch (error) {
    res.status(500).send(error);
  }
};


exports.updateAlcoItems  =  async (req, res) => {
  const { username } = req.params;
  const alcohol = req.body;


  console.log("Getttting ALco");
  try {
    const patient = await Patient.findOne({ username });
    if (!patient) {
      return res.status(404).send({ message: 'Patient not found' });
    }

    const currentDate = moment().format('DD/MM/YYYY');
    let todayRecord = patient.journey.records.find(record => record.date === currentDate);

    if (!todayRecord) {
      todayRecord = struct(currentDate);
      patient.journey.records.push(todayRecord);
    }

    todayRecord.alcohol.consumedAlcoholToday = alcohol.consumedAlcoholToday;
    todayRecord.alcohol.glassesConsumed = alcohol.glassesConsumed;

    await patient.save();
    res.status(200).send(todayRecord);
  } catch (error) {
    res.status(500).send(error);
  }
}
exports.updateWaterItems  =  async (req, res) => {
  const { username } = req.params;
  const water = req.body;


  console.log("Getttting ALco");
  try {
    const patient = await Patient.findOne({ username });
    if (!patient) {
      return res.status(404).send({ message: 'Patient not found' });
    }

    const currentDate = moment().format('DD/MM/YYYY');
    let todayRecord = patient.journey.records.find(record => record.date === currentDate);

    if (!todayRecord) {
      todayRecord = struct(currentDate);
      patient.journey.records.push(todayRecord);
    }

    todayRecord.water.intake = water.intake;


    await patient.save();
    res.status(200).send(todayRecord);
  } catch (error) {
    res.status(500).send(error);
  }
}

exports.updateSleepItems  =  async (req, res) => {
  const { username } = req.params;
  const sleep = req.body;


  console.log("Getttting ALco");
  try {
    const patient = await Patient.findOne({ username });
    if (!patient) {
      return res.status(404).send({ message: 'Patient not found' });
    }

    const currentDate = moment().format('DD/MM/YYYY');
    let todayRecord = patient.journey.records.find(record => record.date === currentDate);

    if (!todayRecord) {
      todayRecord = struct(currentDate);
      patient.journey.records.push(todayRecord);
    }

    todayRecord.sleeping_habits.status = true;
    todayRecord.sleeping_habits.sleep_quality = sleep.sleep_quality;
    todayRecord.sleeping_habits.undisturbed_sleep_hours = sleep.undisturbed_sleep_hours;
    todayRecord.sleeping_habits.nap_duration = sleep.nap_duration;
 


    await patient.save();
    res.status(200).send(todayRecord);
  } catch (error) {
    res.status(500).send(error);
  }
}






// Get journey percentage
exports.getJourneyPercentage = async (req, res) => {
  try {
    const patient = await Patient.findOne({ username: req.params.username });
    if (!patient) {
      return res.status(404).send('Patient not found');
    }
    res.json({ status_percentage: patient.journey.status_percentage || 0 });
  } catch (error) {
    res.status(500).send('Server error');
  }
};

// Update journey percentage
exports.updateJourneyPercentage = async (req, res) => {
  try {
    const patient = await Patient.findOneAndUpdate(
      { username: req.params.username },
      { $set: { 'journey.status_percentage': req.body.status_percentage } },
      { new: true }
    );
    if (!patient) {
      return res.status(404).send('Patient not found');
    }
    res.send('Journey percentage updated');
  } catch (error) {
    res.status(500).send('Server error');
  }
};
