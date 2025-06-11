import * as Repo from '../repo/authRepo.js'
import bcrypt from 'bcrypt'
import  {AppError} from '../../utils/AppError.js'
import {GenerateToken} from '../../utils/GenerateToken.js'
import Doctor from '../../doctor/model/doctorModel.js'

export const Register = async(userData)=>{
    const {userName , email  , password , Cpassword} = userData
    if(password !== Cpassword)
        {
            throw new AppError('passwords are not match!' , 400)
        }
    const olduser = await Repo.FindByEmail(email)
    if(olduser)
        {
            throw new AppError('account is already exists!' , 400)
        }

    const hash_pass = await bcrypt.hash(password , 12)
    const newuser = {
        userName,
        email,
        password : hash_pass,
    } 
    const savedUser = await Repo.saveUser(newuser)
    

    const token = GenerateToken({email: savedUser.email, id: savedUser._id})
    savedUser.token = token
    

    await Repo.saveUser(savedUser)
      const response = {
        token,
        id: savedUser._id
    }

    if (savedUser.role === 'doctor' && savedUser.doctorId) {
        response.doctorId = savedUser.doctorId;
        response.isVerified = savedUser.isVerified;
    }

    return response
}

export const login = async(email, password, res) => {
    const user = await Repo.FindByEmail(email);
        console.log('User from FindByEmail in login:', user);

    if (!user) {
        throw new AppError("user not found!", 404);
    }

    if (!password || !user.password) {
        throw new AppError("Invalid credentials", 400);
    }

    const pass = await bcrypt.compare(password, user.password);
    if (pass) {
        const token = GenerateToken({ email: user.email, id: user._id }, res);        let response = {
            token,
            id: user._id,
            role: user.role  // إضافة الرول للريسبونس
        };

        if (user.role === 'doctor' && user.doctorId) {
            response.doctorId = user.doctorId;
            response.isVerified = user.isVerified;
        }

        // حفظ التوكن في اليوزر
        user.token = token;
        await Repo.saveUser(user);
        return response;
    }

    throw new AppError("password or Email are incorrect!", 500);
}


export const findUserByEmail = async (email) => {
    return await Repo.FindByEmail(email);
};
  
export const generateOTP = () => {
    return Math.floor(100000 + Math.random() * 900000).toString(); // 6-digit OTP
};
  
export const saveOTP = async (userId, otp, otpExpires) => {
    return await Repo.updateById(userId, { otp, otpExpires });
};
  