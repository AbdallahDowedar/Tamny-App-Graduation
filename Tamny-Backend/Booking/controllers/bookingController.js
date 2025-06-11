import * as bookingService from "../services/bookingService.js";
import * as bookingRepo from "../repo/bookingRepo.js";
import {CatchAsync} from "../../utils/CatchAsync.js";

export const bookSlot = CatchAsync (async (req, res) => {
        const { scheduleId, slotId , patientId } = req.body;
        const booking = await bookingService.bookSlot(patientId, scheduleId, slotId);
        res.status(201).json({ success: true, data: booking });
});

export const respondToBooking = CatchAsync(async (req, res) => {
        const { bookingId, accept , doctorId } = req.body; 
        const booking = await bookingService.respondToBooking(bookingId, doctorId, accept);
        res.status(200).json({ success: true, data: booking });
});

export const getDoctorBookings = CatchAsync (async (req, res) => {
        const doctorId = req.params; 
        const bookings = await bookingRepo.findBookingsByDoctor(doctorId);
        res.status(200).json({ success: true, data: bookings });
});

export const getAvailableSlots = CatchAsync(async (req, res) => {
        const { doctorId} = req.params;
        const slots = await bookingService.getAvailableSlots(doctorId);
        res.status(200).json({ success: true, data: slots });
});

export const getDoctorPendingBookings = CatchAsync(async (req, res, next) => {
    const { doctorId } = req.params;
    
    const result = await bookingService.getDoctorPendingBookings(doctorId);
    
    return res.status(200).json(result);
});

export const getUserBookings = CatchAsync (async (req, res) => {
        const patientId = req.params; 
        const bookings = await bookingRepo.findBookingsByUser(patientId);
        res.status(200).json({ success: true, data: bookings });
});