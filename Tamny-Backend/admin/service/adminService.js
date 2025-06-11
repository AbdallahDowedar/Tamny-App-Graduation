import { AppError } from "../../utils/AppError.js";
import * as Repo from "../repo/adminRepo.js"
import Doctor from "../../doctor/model/doctorModel.js";

const approveDoctor =  async(doctorId)=>{

    console.log(doctorId)
    const doctor = await Repo.findById(doctorId);
    if (!doctor) throw new AppError("user not found!" , 404);

    doctor.isVerified = true;
    await doctor.save({ validateBeforeSave: false });
    return { message: "Doctor approved successfully." };
}

const rejectDoctor = async(doctorId)=>{
    const doctor = await Repo.findById(doctorId);//
    if (!doctor) throw new AppError("Doctor not found.",404);
    await Repo.findByIdAndDelete(doctorId);

    return { message: "Doctor rejected" };
}

const deleteDoctor = async(doctorId)=>{
    const doctor = await Repo.findById(doctorId);//
    if (!doctor) throw new AppError("Doctor not found.",404);
    await Repo.findByIdAndDelete(doctorId);
    return { message: "Doctor deleted successfully." };
}

const getDoctorCV = async(doctorId)=>{
    const doctor = await Repo.findById(doctorId);//
    if (!doctor) throw new AppError("Doctor not found.",404);
    if (!doctor.cv) throw new AppError("Doctor has not uploaded a CV.",404);

    return doctor.cv;
}

const getAllDoctors = async() => {
    const getAllDoctors = Repo.getAllDoctors()
    return await getAllDoctors
}


export {
    approveDoctor,
    rejectDoctor,
    deleteDoctor,
    getDoctorCV,
    getAllDoctors
}