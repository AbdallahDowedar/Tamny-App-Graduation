import {findDoctor} from '../repo/scheduling.js'
import { enumRole } from "../../user/userModel.js";
import Schedule from "../model/scheduleModel.js";
import { generateWeeklySlots } from "../services/scheduleService.js";
import {CatchAsync} from "../../utils/CatchAsync.js";

export const setDoctorSchedule = CatchAsync(
    async (req, res, next) => {
        console.log(req.body)

        const { doctorId, workingDays, sessionDuration } = req.body;

        if (!doctorId || !workingDays || !sessionDuration)
            return next(new Error("Missing required fields", { cause: 400 }));

        const slots = await generateWeeklySlots(doctorId, workingDays, sessionDuration);

        if (!slots)
            return next(new Error("Oops something went wrong", { cause: 500 }));

        return res.status(201).json({ message: "done", slots });
    }
);

export const getDoctorSchedule = CatchAsync(
    async (req, res,next) => {        const { doctorId } = req.params;

        const doctor = await findDoctor({ payload: { _id: doctorId } });
        if (!doctor) 
            return next(new Error("Doctor not found", { cause: 404 }));

        const schedule = await Schedule.find({ doctorId });
        
        if (!schedule)
            return next(new Error("Schedule not found", { cause: 404 }));

        return res.status(200).json({ message: "done", schedule });
    }
);
