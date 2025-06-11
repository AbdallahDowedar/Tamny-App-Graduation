import mongoose from 'mongoose';

const rateSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  doctorId: { type: mongoose.Schema.Types.ObjectId, ref: 'Doctor', required: true },
  rate:{type:Number,required:true}
});


export default mongoose.model('Rate', rateSchema);
