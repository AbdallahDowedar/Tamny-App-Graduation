import * as authServices from '../services/authServices.js'
import { CatchAsync } from '../../utils/CatchAsync.js'
import * as Repo from '../repo/authRepo.js'
import { sendEmail } from '../../utils/email.js'
import bcrypt from 'bcrypt'


const Register = CatchAsync(async(req , res , next)=>{
    const {token,id,doctorId,isVerified} = await authServices.Register(req.body)
    return res.status(201).json({
        msg : "done",
        token,
        id,doctorId,isVerified
    })
})

const login = CatchAsync(async(req, res, next) => {
    const { token, id, isVerified, doctorId,role } = await authServices.login(req.body.email, req.body.password, res);
    return res.status(200).json({ success: true, msg: "login successfully", token, id, isVerified, doctorId,role});
});

const forgotPassword = CatchAsync(async (req, res, next) => {
    const { email } = req.body;
    const user = await authServices.findUserByEmail(email);
    if (!user) return res.status(404).json({ message: "User not found" });

    const otp = authServices.generateOTP();
    const otpExpires = Date.now() + 10 * 60 * 1000; // 10 minutes

    await authServices.saveOTP(user._id, otp, otpExpires);
    await sendEmail(user.email, `Your OTP code is: ${otp}`);

    res.status(200).json({ message: "OTP sent to email" });
});

const verifyOTP = CatchAsync(async (req, res, next) => {
    const { email, otp } = req.body;
    const user = await authServices.findUserByEmail(email);
    if (!user) return res.status(404).json({ message: "User not found" });

    const now = Date.now();
    if (user.otp !== otp || user.otpExpires < now) {
        return res.status(400).json({ message: "Invalid or expired OTP" });
    }

    res.status(200).json({ message: "OTP verified" });
});

const resetPassword = CatchAsync(async (req, res, next) => {
    const { email, otp, newPassword } = req.body;
    const user = await authServices.findUserByEmail(email);
    if (!user || user.otp !== otp || user.otpExpires < Date.now()) {
        return res.status(400).json({ message: "Invalid or expired OTP" });
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);
    await Repo.updateById(user._id, {
        password: hashedPassword,
        otp: null,
        otpExpires: null,
    });
  
    res.status(200).json({ message: "Password reset successful" });
});
  



export {
    Register,
    login,
    forgotPassword,
    verifyOTP,
    resetPassword
}