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
    intake: Number
  },
  alcohol: {
    consumedAlcoholToday: String,
    glassesConsumed: Number,
  },
  smoke: {
    consumed_smoke_today: String,
    cigarettes_consumed: Number
  }
});

const medicationReminderSchema = new mongoose.Schema({
  date: { type: Date, required: true },
  time: { type: String, required: true }
});

const medicationListSchema = new mongoose.Schema({
  name: { type: String, required: true },
  start_date: { type: Date, required: true },
  end_date: { type: Date, required: true },
  times: [{ type: String, required: true }]
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
    medication_list: [medicationListSchema]
  }
});

module.exports = mongoose.model('Patient', patientSchema);
