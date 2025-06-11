process.env['NODE_TLS_REJECT_UNAUTHORIZED'] = '0';
import express from 'express';
import mongoose from 'mongoose';
import dotenv from 'dotenv';
dotenv.config({path: './config/.env' })
import {generatePlan} from './aiChat/chat.js'

// MongoDB Connection with proper options
mongoose.connect(process.env.URI, {
    serverSelectionTimeoutMS: 30000, // Timeout after 30s instead of 10s
    socketTimeoutMS: 45000, // Close sockets after 45 seconds of inactivity
})
.then(() => console.log('Connected to MongoDB'))
.catch((err) => console.error('MongoDB connection error:', err));

// Handle MongoDB connection errors
mongoose.connection.on('error', err => {
    console.error('MongoDB connection error:', err);
});

mongoose.connection.on('disconnected', () => {
    console.log('MongoDB disconnected. Attempting to reconnect...');
});

mongoose.connection.on('connected', () => {
    console.log('MongoDB connected successfully');
});

const app = express();
app.use(express.json())

import * as authRoutes from './Auth/routes/authRoutes.js'
app.use('/auth' , authRoutes.default)

import * as doctorRoutes from './doctor/routes/doctorRoutes.js'
app.use('/doctor' ,doctorRoutes.default)

import * as adminRoutes from './admin/routes/adminRoutes.js'
app.use('/admin',adminRoutes.default)

import specializationRoutes from './specialization/specializationRoutes.js';
app.use('/specialization', specializationRoutes);


app.use('/uploads', express.static('uploads'));
import * as DoctorSchedule from "./Doctor Schedule/routes/scheduleRoutes.js";
app.use("/doctor/schedule", DoctorSchedule.default);

import * as BookingRoutes from './Booking/routes/bookingRoutes.js';
app.use('/booking', BookingRoutes.default)

import locationRoutes from "./locations/routes/locationRoutes.js";
app.use('/location', locationRoutes);

import AreaRoute from "./area/routes/areaRoutes.js";
app.use('/area', AreaRoute);

import RateRoute from "./rateing/router/rateRoute.js";
app.use('/rate', RateRoute);

app.post('/ai', async (req, res) => {
    const userSymptoms = req.body;
    
    // التحقق من المدخلات
    if (!userSymptoms) {
      return res.status(400).json({ error: "يجب إدخال جميع البيانات المطلوبة" });
    }
  
    const plan = await generatePlan(userSymptoms);
    console.log('الأعراض المرسلة:', userSymptoms);
    if (plan) {
      res.json(plan);
    } else {      res.status(500).json({ error: "❌ فشل إنشاء الخطة" });
    }
  });

// Start server after MongoDB connects
mongoose.connection.once('connected', () => {
    app.listen(process.env.PORT, () => {
        console.log(`Server is running on port ${process.env.PORT}`);
    });
});


