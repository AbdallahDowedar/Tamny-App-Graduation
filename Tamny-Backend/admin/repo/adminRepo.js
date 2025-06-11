import Doctor from '../../doctor/model/doctorModel.js'

const findById = async(doctorId)=>{
    return await Doctor.findById(doctorId) 
}

const findByIdAndDelete = async(doctorId)=>{
    return await Doctor.findByIdAndDelete(doctorId) 
}

const getAllDoctors = () => {
    return Doctor.find().populate('user','userName -_id').select('_id isVerified description nickName').populate('specialization','name -_id').populate('locations','name -_id')
}

export  {
    findById,
    findByIdAndDelete,
    getAllDoctors
}