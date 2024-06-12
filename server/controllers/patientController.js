const Patient = require('../models/patient.js');
const moment = require('moment');
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
      registered_Date: '', // This should ideally be set to the current date but left empty as per request
      records: [
        {
          date: '',
          status_percentage: null,
          status: false,
          food: {
            status: false,
            Fruits: [
              { name: '', quantity: '' },
              { name: '', quantity: '' }
            ],
            Vegetables: [
              { name: '', quantity: '' },
              { name: '', quantity: '' }
            ],
            Sprouts_and_Nuts: [
              { name: '', quantity: '' },
              { name: '', quantity: '' }
            ],
            Spinach: [
              { name: '', quantity: '' }
            ],
            Baked_Items: [
              { name: '', quantity: '' }
            ],
            Non_Veg: [
              { name: '', quantity: '' }
            ],
            Salt: [
              { name: '', quantity: '' }
            ],
            Drinks: [
              { name: '', quantity: '' }
            ],
          },
          excersies: {
            status: false,
            actions: [
              { name: '', status: '', durationMinutes: null, reason: '' },
              { name: '', status: '', durationMinutes: null, reason: '' },
              { name: '', status: '', durationMinutes: null, reason: '' },
            ]
          },
          sleeping_habits: {
            status: false,
            sleep_quality: '',
            undisturbed_sleep_hours: '',
            nap_duration: ''
          },
          water: {
            status: false,
            intake: null
          },
          alcohol: {
            isHave: false,
            consumed_alcohol_today: '',
            glasses_consumed: null
          },
          smoke: {
            isHave: false,
            consumed_smoke_today: '',
            cigarettes_consumed: null
          }
        }
      ]
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
      medication_list: [
        {
          name: '',
          start_date: '',
          end_date: '',
          times: [
            { name: '', time: '' },
            { name: '', time: '' },
            { name: '', time: '' },
          ]
        }
      ]
    }
  });

  try {
    await newPatient.save();
    res.status(201).send(newPatient);
  } catch (error) {
    res.status(500).send(error);
  }
};


exports.updatePatientProfile = async (req, res) => {
  const { username } = req.params;
  const { password, name, age, gender, maritalStatus, occupation, alcohol, smoke, journey } = req.body;

  try {
    // Find the patient by username
    let patient = await Patient.findOne({ username });

    if (!patient) {
      return res.status(404).send({ message: 'Patient not found' });
    }

    // Update the patient's details
    patient.password = password || patient.password;
    patient.name = name || patient.name;
    patient.age = age || patient.age;
    patient.gender = gender || patient.gender;
    patient.maritalStatus = maritalStatus || patient.maritalStatus;
    patient.occupation = occupation || patient.occupation;
    patient.alcohol = alcohol != null ? alcohol : patient.alcohol;
    patient.smoke = smoke != null ? smoke : patient.smoke;
    patient.journey.registered_Date = journey.registered_Date || patient.journey.registered_Date;

    // Save the updated patient
    await patient.save();

    res.status(200).send(patient);
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


exports.getJourneyStatus = async (req, res) => {
  const { username } = req.params;
  const currentDate = moment().format('DD/MM/YYYY');
  console.log(`Fetching journey status for user: ${username}`);

  try {
    const patient = await Patient.findOne({ username });
    if (!patient) {
      console.log(`Patient not found with username: ${username}`);
      return res.status(404).send({ message: 'Patient not found' });
    }

    let todayRecord = patient.journey.records.find(record => record.date === currentDate);

    if (!todayRecord) {
      console.log(`No record found for today (${currentDate}) for user: ${username}`);
      todayRecord = {
        date: currentDate,
        status_percentage: 0,
        status: false,
        food: { status: false },
        exercise: { status: false },
        smoking: { status: false },
        alcohol: { status: false },
        smoke: { status: false },
        sleep: { status: false },
        water: { status: false },
      };
      patient.journey.records.push(todayRecord);
      await patient.save();
    }

    console.log(todayRecord);
    console.log(`Successfully fetched journey status for user: ${username}`);
    res.status(200).send(todayRecord);
  } catch (error) {
    console.error(`Error fetching journey status for user: ${username}`, error);
    res.status(500).send(error);
  }
};

exports.updateJourneyStatus = async (req, res) => {
  const { username } = req.params;
  var { key, value } = req.body;
  const currentDate = moment().format('DD/MM/YYYY');
  console.log(`Updating journey status for user: ${username}`);

  try {
    const patient = await Patient.findOne({ username });
    if (!patient) {
      console.log(`Patient not found with username: ${username}`);
      return res.status(404).send({ message: 'Patient not found' });
    }

    let todayRecord = patient.journey.records.find(record => record.date === currentDate);
    
    console.log(todayRecord);
    // todayRecord

    if (!todayRecord) {
      console.log(`No record found for today (${currentDate}) for user: ${username}`);
      return res.status(404).send({ message: 'Record for today not found' });
    }

    console.log(key+" "+value);

    value = Math.ceil(value)
    todayRecord.status_percentage = value
    
    if(value==100){
      todayRecord.status = true
      }else{
      todayRecord.status = false

    }

    await patient.save();


    console.log(`Successfully updated journey status for user: ${username}`);
    res.status(200).send(todayRecord);
  } catch (error) {
    console.error(`Error updating journey status for user: ${username}`, error);
    res.status(500).send(error);
  }
};



exports.updateFoodItems = async (req, res) => {
  const { username,food } = req.params;
  const foodItems = req.body;

  items = foodItems.food[food];

  try {
    const patient = await Patient.findOne({ username });
    if (!patient) {
      console.log(`Patient not found with username: ${username}`);
      return res.status(404).send({ message: 'Patient not found' });
    }

    const currentDate = moment().format('DD/MM/YYYY');
    let todayRecord = patient.journey.records.find(record => record.date === currentDate);

    console.log(todayRecord);

    if (!todayRecord) {
      console.log(`No record found for today (${currentDate}) for user: ${username}`);
      todayRecord = {
        date: currentDate,
        status_percentage: 0,
        status: false,
        food: { status: false },
        exercise: { status: false },
        smoking: { status: false },
        alcohol: { status: false },
        sleep: { status: false },
        water: { status: false },
      };
      patient.journey.records.push(todayRecord);
    }

    todayRecord.food[food] = items;

    await patient.save();

    console.log(`Successfully updated ${food} items for user: ${username}`);
    res.status(200).send(todayRecord);
  } catch (error) {
    console.error(`Error updating baked items for user: ${username}`, error);
    res.status(500).send(error);
  }
};
exports.updateSmokeItems = async (req, res) => {
  const { username,food } = req.params;
  const smoke = req.body;


  try {
    const patient = await Patient.findOne({ username });
    if (!patient) {
      console.log(`Patient not found with username: ${username}`);
      return res.status(404).send({ message: 'Patient not found' });
    }

    const currentDate = moment().format('DD/MM/YYYY');
    let todayRecord = patient.journey.records.find(record => record.date === currentDate);


    if (!todayRecord) {
      console.log(`No record found for today (${currentDate}) for user: ${username}`);
      todayRecord = {
        date: currentDate,
        status_percentage: 0,
        status: false,
        food: { status: false },
        exercise: { status: false },
        smoking: { status: false },
        alcohol: { status: false },
        sleep: { status: false },
        water: { status: false },
      };
      patient.journey.records.push(todayRecord);
    }

    todayRecord.smoke = smoke;
    todayRecord.smoke.status = true;

    await patient.save();

    console.log(`Successfully updated ${smoke} items for user: ${username}`);
    res.status(200).send(todayRecord);
  } catch (error) {
    console.error(`Error updating ${smoke} items for user: ${username}`, error);
    res.status(500).send(error);
  }
};