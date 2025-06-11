import express from "express";
import * as bookingController from "../controllers/bookingController.js";
import { verifying } from "../../middlewares/verifying.js";

const router = express.Router();

//get available slots for a doctor
router.get("/slots/:doctorId", bookingController.getAvailableSlots);

//book a slot
router.post("/book", bookingController.bookSlot);

//respond to booking request
router.put("/respond", bookingController.respondToBooking);

//get bookings for a doctor
router.get("/bookings/:doctorId", bookingController.getDoctorBookings);

router.get("/userBookings/:patientId", bookingController.getUserBookings);
// get pending bookings for a specific doctor
router.get(
  "/doctor/:doctorId",
  bookingController.getDoctorPendingBookings
);

export default router;