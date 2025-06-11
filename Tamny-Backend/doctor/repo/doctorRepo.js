import Doctor from '../model/doctorModel.js';


const findDoctorByEmail = async (email) => {
  return await Doctor.findOne({ email });
};

const findDoctorById = async (id) => {
  return await Doctor.findById(id);
};

const createDoctor = async (doctorData) => {
  const newDoctor = new Doctor(doctorData);
  return await newDoctor.save();
};

const updateDoctor = async (id, updateData) => {
  return await Doctor.findByIdAndUpdate({_id : id}, {$set : {...updateData}}, { new: true });
};

const updateDoctorCV = async (id, cvPath) => {
  return await Doctor.updateOne({_id : id} , {$set : {cv : cvPath}} ,{new : true});
};


const findDoctorsByName = async (name) => {
  const doctors = await Doctor.find()
  .populate({path: 'user',match: { userName: { $regex: name, $options: 'i' } },select: 'userName'})
  .populate({
    path: 'specialization',
    select: 'name' // غيرها حسب اسم الحقل في Specialization
  })
  .populate({
    path: 'locations',
    select: 'name' // غيرها حسب اسم الحقل في Location
  })
  .lean();

  return doctors
    .filter(doctor => doctor.user)
    .map(doctor => ({
      id: doctor._id,
      userName: doctor.user.userName,
      specialization: doctor.specialization?.name || null,
      locations: doctor.locations?.name || null,
      consultationFees: doctor.consultationFees,
      rate: doctor.rate,
      area: doctor.area,
      description: doctor.description || null,
      nickName: doctor.nickName || null,
      phone : doctor.phone || null,
    }));
};

const findDoctorsByArea = async (area) => {
  const doctors = await Doctor.find({
    area: { $regex: area, $options: 'i' } // بحث غير حساس للحروف
  })
  .populate({
    path: 'specialization',
    select: 'name'
  })
  .populate({
    path: 'locations',
    select: 'name'
  })
  .populate({
    path: 'user',
    select: 'userName'
  })
  .lean();

  return doctors
    .filter(doctor => doctor.user) // ممكن كمان تشيلها لو ضمنت وجود user
    .map(doctor => ({
      id: doctor._id,
      userName: doctor.user.userName,
      specialization: doctor.specialization?.name || null,
      locations: Array.isArray(doctor.locations) ? doctor.locations.map(loc => loc.name) : null,
      consultationFees: doctor.consultationFees,
      rate: doctor.rate,
      area: doctor.area,
      description: doctor.description || null,
      nickName: doctor.nickName || null,
      phone: doctor.phone || null,
    }));
};




const findByPrice = async(consultationFees)=>{
  return await Doctor.find({consultationFees:{$lte:consultationFees}})
}




export { findDoctorByEmail, findDoctorById, createDoctor, updateDoctor, updateDoctorCV,findDoctorsByName,findByPrice,findDoctorsByArea };
