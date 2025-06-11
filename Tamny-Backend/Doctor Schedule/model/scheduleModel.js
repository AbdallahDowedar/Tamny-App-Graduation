import mongoose from "mongoose";

const slotSchema = new mongoose.Schema({
    startTime: String,
    endTime: String,
    isBooked: { type: Boolean, default: false },
    status: { type: String, enum: ["available", "pending", "confirmed"], default: "available" }
});

const scheduleSchema = new mongoose.Schema({
    doctorId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    day: { type: String, required: true },
    date: { type: String, required: true },
    slots: [slotSchema]
});

export default mongoose.model("Schedule", scheduleSchema);