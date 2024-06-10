joson = {
  username: "hell",

  password: "123",

  name: "Hello",

  age: 67,

  gender: "Male",

  maritalStatus: "Married",

  occupation: "uu",

  alcohol: true,

  smoke: true,

  journey : {
    resgistered_Date: "Registred Date in DD/MM/YYYY",
  
    records: [
      {
        date: "Date in DD/MM/YYYY",
        status_percentage: 70,
        status: true,
        food: {
          status: true,
          Fruits: [
            {
              name: "Apple",
              quantity: "5",
            },
            {
              name: "Banana",
              quantity: "10",
            },
          ],
  
          Vegetables: [
            {
              name: "Carrot",
              quantity: "3",
            },
            {
              name: "Broccoli",
              quantity: "2",
            },
          ],
  
          Sprouts_and_Nuts: [
            {
              name: "Almonds",
              quantity: "200g",
            },
            {
              name: "Walnuts",
              quantity: "150g",
            },
          ],
          Spinach: [
            {
              name: "Spinach Leaves",
              quantity: "500g",
            },
          ],
          Baked_Items: [
            {
              name: "Bread",
              quantity: "2 loaves",
            },
          ],
  
          Non_Veg: [
            {
              name: "Chicken",
              quantity: "1kg",
            },
          ],
          Salt: [
            {
              name: "Amount of salt added ",
              quantity: "500g",
            },
          ],
          Drinks: [
            {
              name: "milk",
              quantity: "12",
            },
          ],
        },
  
        excersies: {
          status: true,
          actions: [
            {
              name: "Warm Up",
              status: "completed",
            },
            {
              name: "Walking",
              status: "stopped",
              durationMinutes: null,
              reason: "pain",
            },
            {
              name: "Cool Down",
              status: "completed",
            },
          ],
        },
  
        sleeping_habits: {
          status: true,
          sleep_quality: "undisturbed",
          undisturbed_sleep_hours: "4-6 hrs",
          nap_duration: "<1 hr",
        },
  
        water: {
          status: true,
          intake: 20,
        },
  
        //the next two will change based on the registration
        alcohol: {
          isHave: true,
          consumed_alcohol_today: "yes", // example value
          glasses_consumed: 3,
        },
  
        smoke: {
          isHave: true,
          consumed_smoke_today: "yes", // example value
          cigerates_consumed: 3,
        },
      },
    ],
  },

  patient_details : {
    height: 170,
    weight: 70,
    bp: "120/80",
    waist_circumference: 85,
    fasting_blood_sugar: 90,
    ldl_cholesterol: 100,
    hdl_cholesterol: 50,
    triglyceride: 150,
    medication_list: [
      {
        name: "Dolo",
        start_date: "",
        end_date: "",
        times: [
          {
            name: "Time 1",
            time: "",
          },
          {
            name: "Time 1",
            time: "",
          },
          {
            name: "Time 1",
            time: "",
          },
        ],
      },
    ],
  }
}

