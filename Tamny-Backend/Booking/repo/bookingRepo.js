import Booking from "../model/bookingModel.js";
import Schedule from "../../Doctor Schedule/model/scheduleModel.js";

export const createBooking = async (bookingData) => {
    return await Booking.create(bookingData);
};

export const updateBookingStatus = async (bookingId, status) => {
    return await Booking.findByIdAndUpdate(bookingId, { status }, { new: true });
};

export const findBookingsByDoctor = async ({ doctorId }) => {
  const bookings = await Booking.find({ doctorId })
    .populate("patientId", "userName email")
    .populate("scheduleId");

  const filteredBookings = bookings.map((booking) => {
    const schedule = booking.scheduleId;
    const filteredSlots = schedule.slots.filter(
      (slot) => slot._id.toString() === booking.slotId.toString()
    );

    return {
      ...booking.toObject(),
      scheduleId: {
        ...schedule.toObject(),
        slots: filteredSlots,
      },
    };
  });

  return filteredBookings;
};

export const findScheduleById = async (scheduleId) => {
    return await Schedule.findById(scheduleId);
};

export const updateSlotStatus = async (scheduleId, slotId, updates) => {
    return await Schedule.findOneAndUpdate(
        { _id: scheduleId, "slots._id": slotId },
        { $set: { "slots.$.status": updates.status, "slots.$.patientId": updates.patientId, "slots.$.isBooked": updates.isBooked } },
        { new: true }
    );
};

export const findAvailableSlots = async (doctorId) => {
    return await Schedule.find({ doctorId,"slots.status": "available" });
};

export const findPendingBookingsByDoctor = async (doctorId) => {
    const bookings = await Booking.find({ 
        doctorId: doctorId,
        status: "pending"
    })
    .populate("patientId", "userName email")
    .populate("scheduleId")
    .sort({ createdAt: -1 }); // الأحدث أولاً

    // تعديل النتائج لتضمين فقط الslot المطلوب
    const modifiedBookings = bookings.map(booking => {
        const schedule = booking.scheduleId;
        if (schedule && schedule.slots) {
            const slot = schedule.slots.find(slot => slot._id.toString() === booking.slotId.toString());
            if (slot) {
                return {
                    ...booking._doc,
                    scheduleId: {
                        ...schedule._doc,
                        slots: [slot] // إرجاع فقط الslot المطلوب
                    }
                };
            }
        }
        return booking;
    });

    return modifiedBookings;
};

export const findBookingsByUser = async ({ patientId }) => {
  const bookings = await Booking.find({ patientId })
    .populate("scheduleId");

  const filteredBookings = bookings.map((booking) => {
    const schedule = booking.scheduleId;
    const filteredSlots = schedule.slots.filter(
      (slot) => slot._id.toString() === booking.slotId.toString()
    );

    return {
      ...booking.toObject(),
      scheduleId: {
        ...schedule.toObject(),
        slots: filteredSlots,
      },
    };
  });

  return filteredBookings;
};
