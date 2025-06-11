import express from "express";
import { setDoctorSchedule, getDoctorSchedule } from "../controllers/scheduleController.js";

const router = express.Router();

router.post("/set-schedule", setDoctorSchedule); 
router.get("/get-schedule/:doctorId", getDoctorSchedule);

export default router;
