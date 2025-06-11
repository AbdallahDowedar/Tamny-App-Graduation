import Rate from '../model/rateModel.js'
import Doctor from '../../doctor/model/doctorModel.js';

export const createrate = async (userId, doctorId, rate) => {
  const doctor = await Doctor.findById(doctorId);
  if (!doctor) {
    throw new Error('Doctor not found');
  }

  doctor.rateNumber = (doctor.rateNumber || 0) + 1;
  const newRate = doctor.rate || 0;
  doctor.rate = ((newRate * (doctor.rateNumber - 1)) + Number(rate)) / doctor.rateNumber;
  
  await doctor.save();

  return Rate.create({ userId, doctorId, rate });
};

