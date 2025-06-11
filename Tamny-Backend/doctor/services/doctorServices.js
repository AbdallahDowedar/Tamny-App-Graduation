import mongoose from 'mongoose';
import bcrypt from 'bcrypt';
import { AppError } from '../../utils/AppError.js';
import { GenerateToken } from '../../utils/GenerateToken.js';
import { findDoctorByEmail, createDoctor, updateDoctor, updateDoctorCV, findDoctorsByName ,findDoctorById,findByPrice,findDoctorsByArea} from '../repo/doctorRepo.js';
import * as AuthRepo from "../../Auth/repo/authRepo.js"
import Doctor from "../model/doctorModel.js"
import * as LocationRepo from '../../locations/repository/locationRepo.js';

const registerDoctor = async (userData) => {
  const { userName, email, password, specialization, consultationFees, phone, locations, addresses, description, rate,area,nickName } = userData;

  if (!email || typeof email !== 'string') {
    throw new AppError('Email is required and must be a string', 400);
  }

  const oldUser = await AuthRepo.FindByEmail(email);
  if (oldUser) {
    throw new AppError('Account already exists!', 400);
  }

  const hash_pass = await bcrypt.hash(password, 12);
  const newUser = {
    userName,
    email,
    password: hash_pass,
    role: 'doctor',
  };

  // احفظ المستخدم أولاً
  const savedUser = await AuthRepo.saveUser(newUser);

  // بعد الحفظ هيكون عندك savedUser._id
  const token = GenerateToken({ email: savedUser.email, id: savedUser._id });
  savedUser.token = token;

  // احفظ التوكن بعد توليده
  await AuthRepo.saveUser(savedUser);

  const newDoctor = {
    user: savedUser._id,
    specialization,
    consultationFees,
    phone,
    locations,
    addresses,
    description,
    rate,
    area,
    nickName
  };

  await createDoctor(newDoctor);

  // مفيش داعي تدور على الدكتور تاني، انت بالفعل عندك الـ user.id
  const id = savedUser._id;
  return { token, id };
};

const loginDoctor = async (email, password, res) => {
  const doctor = await findDoctorByEmail(email);
  if (!doctor) {
    throw new AppError("Doctor not found!", 404);
  }

  const isMatch = await bcrypt.compare(password, doctor.password);
  if (!isMatch) {
    throw new AppError("Password or email is incorrect!", 401);
  }

  const token = GenerateToken({ email: doctor.email, id: doctor._id }, res);
  doctor.token = token;
  await updateDoctor(doctor._id, doctor);
  return token;
};

const updateDoctorProfile = async (id, updateData) => {
  const updatedDoctor = await updateDoctor(id, updateData);
  if (!updatedDoctor) throw new AppError("no data", 401);
  return updatedDoctor;
};

const uploadDoctorCV = async (id, cvPath) => {
  const updatedDoctor = await updateDoctorCV(id, cvPath);
  if (!updatedDoctor) throw new AppError("no data", 401);
  return updatedDoctor;
};

const filterDoctors = async (filters) => {
  try {
    const { specialization, location, area, page = 1, limit = 10 } = filters;
    const query = {};

    if (specialization) {
      query.specialization = new mongoose.Types.ObjectId(specialization);
    }

    if (location) {
      query.locations =  new mongoose.Types.ObjectId(location);;
    }

    if (area) {
      query.area = area;
    }

    const skip = (page - 1) * limit;

    const doctors = await Doctor.aggregate([
      {
        $lookup: {
          from: 'users',
          localField: 'user',
          foreignField: '_id',
          as: 'userData'
        }
      },
      {
        $lookup: {
          from: 'specializations',
          localField: 'specialization',
          foreignField: '_id',
          as: 'specializationData'
        }
      },
      {
        $lookup: {
          from: 'locations',
          localField: 'locations',
          foreignField: '_id',
          as: 'locationData'
        }
      },      {
        $match: query
      },
      {
        $project: {
          _id: 1,
          userName: { $arrayElemAt: ['$userData.userName', 0] },
          specialization: { $arrayElemAt: ['$specializationData.name', 0] },
          locations: { $arrayElemAt: ['$locationData.name', 0] },
          consultationFees: 1,
          rate: 1,
          description: 1,
          nickName: 1,
          phone: 1
        }
      },
      { $skip: skip },
      { $limit: limit }
    ]);

    const totalCount = await Doctor.countDocuments(query);    const formattedDoctors = doctors.map(doctor => ({
      id: doctor._id,
      userName: doctor.userName,
      specialization: doctor.specialization,
      locations: doctor.locations,
      consultationFees: doctor.consultationFees,
      rate: doctor.rate,
      description: doctor.description || null,
      nickName: doctor.nickName || null,
      phone: doctor.phone || null,
    }));

    return { success: true, data: formattedDoctors };
  } catch (error) {
    console.error("Error fetching doctors:", error);
    throw new AppError("Failed to fetch doctors");
  }
};

const searchDoctorsByName = async (name) => {
  if (typeof name !== 'string') {
    throw new AppError('Name must be a string');
  }
  const Doctor = await findDoctorsByName(name)
  return Doctor;
};

const searchDoctorsByArae = async (area) => {
  if (typeof area !== 'string') {
    throw new AppError('area must be a string');
  }
  const Doctor = await findDoctorsByArea(area)
  return Doctor;
};

const newSearch = async (name, specialization, location, page = 1, limit = 10) => {
  try {
    if (!name || !specialization || !location) {
      throw new AppError('Name, specialization, and location are all required for this search', 400);
    }

    if (!mongoose.Types.ObjectId.isValid(specialization) || !mongoose.Types.ObjectId.isValid(location)) {
      throw new AppError('Invalid specialization or location ID', 400);
    }

    const skip = (page - 1) * limit;

    const doctors = await Doctor.aggregate([
      {
        $lookup: {
          from: 'users',
          localField: 'user',
          foreignField: '_id',
          as: 'userData'
        }
      },
      {
        $lookup: {
          from: 'specializations',
          localField: 'specialization',
          foreignField: '_id',
          as: 'specializationData'
        }
      },
      {
        $lookup: {
          from: 'locations',
          localField: 'locations',
          foreignField: '_id',
          as: 'locationData'
        }
      },
      {
        $match: {
          'userData.userName': { $regex: name, $options: 'i' },
          'specialization': new mongoose.Types.ObjectId(specialization),
          'locations': new mongoose.Types.ObjectId(location)
        }
      },
      {
        $project: {
          _id: 1,
          userName: { $arrayElemAt: ['$userData.userName', 0] },
          specialization: { $arrayElemAt: ['$specializationData.name', 0] },
          locations: { $arrayElemAt: ['$locationData.name', 0] },
          consultationFees: 1,
          rate: 1
        }
      },
      { $skip: skip },
      { $limit: limit }
    ]);

    return doctors.map(doctor => ({
      id: doctor._id,
      userName: doctor.userName,
      specialization: doctor.specialization,
      locations: doctor.locations,
      consultationFees: doctor.consultationFees,
      rate: doctor.rate
    }));
  } catch (error) {
    console.error("Error searching doctors:", error);
    throw new AppError("Failed to search doctors");
  }
};

const getSingleDoctor = async(id)=>{
  const doctor = await findDoctorById(id);
  if (!doctor) {
    throw new AppError('Doctor not found',400);
  }
  return doctor;
}

const filterPrice = async(price)=>{
  const doctors = await findByPrice(price)
  return doctors
}

export { registerDoctor, loginDoctor, updateDoctorProfile, uploadDoctorCV, filterDoctors, searchDoctorsByName, newSearch ,getSingleDoctor,filterPrice,searchDoctorsByArae};
