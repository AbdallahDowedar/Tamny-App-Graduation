import  mongoose from 'mongoose'

export const enumRole = {
    patient: 'patient',
    doctor: 'doctor',
    admin: 'admin'
}
export const enumStatus = {
    binding: 'pinding',
    aproved: 'approved',
}

const userSchema = new mongoose.Schema({
    userName: {
        type: String,
        required: true,
        minlength: [3, "Username must be at least 3 characters long"],
        maxlength: [50, "Username must be at most 50 characters long"],
    },
    email: {
        type: String,
        required: true,
        unique: true,
        match: [/^[^\s@]+@[^\s@]+\.[^\s@]+$/, 'Please enter a valid email address'] , 
        validate: {
            validator: function (value) {
              return value !== null; 
            },
            message: 'Email cannot be null',
          },
    },
    password: {
        type: String,
        unique: true,
        sparse: true,
        match: [/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$/, 'Password must contain at least one number, one uppercase letter, one lowercase letter, and one special character'],
    },
    role: {
        type: String,
        enum: Object.values(enumRole),
        default: enumRole.patient
    },
    otp: String,
    otpExpires: Date,
})

const User = mongoose.model('User', userSchema)
export default User