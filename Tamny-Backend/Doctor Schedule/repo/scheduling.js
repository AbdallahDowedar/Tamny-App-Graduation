import scheduleModel from "../model/scheduleModel.js";
import User from "../../user/userModel.js";
import Doctor from "../../doctor/model/doctorModel.js";
export const findUser = async ({payload}) => {
    return await User.findOne(payload);
}

export const findDoctor = async ({payload}) => {
    return await Doctor.findById(payload._id);
}

export const setSchedule = async (availableSlots) => {
    return await scheduleModel.insertMany(availableSlots);
}


export const delSchedule = async ({payload}) => {
    return await scheduleModel.deleteOne(payload);
}