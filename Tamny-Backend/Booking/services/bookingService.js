import * as bookingRepo from "../repo/bookingRepo.js";
import { AppError } from "../../utils/AppError.js";

export const bookSlot = async (patientId, scheduleId, slotId) => {
    const schedule = await bookingRepo.findScheduleById(scheduleId);
    if (!schedule) throw new AppError("Schedule not found" , 404);

    const slot = schedule.slots.id(slotId);
    if (!slot || slot.status !== "available") throw new Error("Slot not available");

    await bookingRepo.updateSlotStatus(scheduleId, slotId, {
        status: "pending",
        patientId,
        isBooked: true
    });

    const booking = await bookingRepo.createBooking({
        patientId,
        doctorId: schedule.doctorId,
        scheduleId,
        slotId
    });

    return booking;
};

export const respondToBooking = async (bookingId, doctorId, accept) => {
    const booking = await bookingRepo.updateBookingStatus(bookingId, accept ? "confirmed" : "rejected");
    if (!booking || booking.doctorId.toString() !== doctorId) throw new AppError("Unauthorized or booking not found" , 404);

    const status = accept ? "confirmed" : "available";
    const updates = { status, isBooked: accept, patientId: accept ? booking.patientId : null };
    await bookingRepo.updateSlotStatus(booking.scheduleId, booking.slotId, updates);

    return booking;
};

export const getAvailableSlots = async (doctorId) => {
    const schedules = await bookingRepo.findAvailableSlots(doctorId);
    return schedules.map(schedule => ({
        scheduleId: schedule._id,
        day: schedule.day,
        date: schedule.date,
        slots: schedule.slots.filter(slot => slot.status === "available")
    }));
};

export const getDoctorPendingBookings = async (doctorId) => {
    if (!doctorId) {
        throw new AppError('Doctor ID is required', 400);
    }

    const bookings = await bookingRepo.findPendingBookingsByDoctor(doctorId);
    
    if (!bookings || bookings.length === 0) {
        return { message: "No pending bookings found", bookings: [] };
    }

    return {
        message: "Pending bookings retrieved successfully",
        count: bookings.length,
        bookings
    };
};