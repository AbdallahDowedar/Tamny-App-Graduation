import mongoose  from "mongoose";

const doctorSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  specialization: { 
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Specialization', 
    required: true 
  },
  consultationFees: { type: Number },
  isVerified: { type: Boolean, default: false },
  locations: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Location',
    required: true,  
  },
  area: {
    type: String,
    required: true,  
  },
    city: { type: String}
  ,
  description:{
    type:String,
    require:true
  },
  phone:{
    type:String
  },
  rate:{
    type:Number,
    default:0
  },
  nickName:{
    type:String
  },
  rateNumber:{
    type:Number,
    default:0
  }
});

const Doctor = mongoose.model("Doctor", doctorSchema);

export default Doctor;

