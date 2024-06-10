const mongoose = require('mongoose');

const foodSchema = new mongoose.Schema({
  name: String,
  quantity: String
});

const exerciseSchema = new mongoose.Schema({
  name: String,
  status: String,
  durationMinutes: String,
  reason: String
});

const recordSchema = new mongoose.Schema({
  date: String,
  status_percentage: Number,
  status: Boolean,
  food: {
    status: Boolean,
    Fruits: [foodSchema],
    Vegetables: [foodSchema],
    Sprouts_and_Nuts: [foodSchema],
    Spinach: [foodSchema],
    Baked_Items: [foodSchema],
    Non_Veg: [foodSchema],
    Salt: [foodSchema],
    Drinks: [foodSchema]
  },
  exercises: {
    status: Boolean,
    actions: [exerciseSchema]
  },
  sleeping_habits: {
    status: Boolean,
    sleep_quality: String,
    undisturbed_sleep_hours: String,
    nap_duration: String
  },
  water: {
    status: Boolean,
    intake: Number
  },
  alcohol: {
    isHave: Boolean,
    consumed_alcohol_today: String,
    glasses_consumed: Number
  },
  smoke: {
    isHave: Boolean,
    consumed_smoke_today: String,
    cigarettes_consumed: Number
  }
});

const patientSchema = new mongoose.Schema({
  username: String,
  password: String,
  name: String,
  age: String,
  gender: String,
  maritalStatus: String,
  occupation: String,
  alcohol: Boolean,
  smoke: Boolean,
  journey: {
    registered_Date: String,
    records: [recordSchema]
  },
  patient_details: {
    height: Number,
    weight: Number,
    bp: String,
    waist_circumference: Number,
    fasting_blood_sugar: Number,
    ldl_cholesterol: Number,
    hdl_cholesterol: Number,
    triglyceride: Number,
    medication_list: [{
      name: String,
      start_date: String,
      end_date: String,
      times: [{
        name: String,
        time: String
      }]
    }]
  }
});

module.exports = mongoose.model('Patient', patientSchema);
