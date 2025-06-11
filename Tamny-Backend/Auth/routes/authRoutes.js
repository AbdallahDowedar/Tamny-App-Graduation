import express from 'express'
const router = express.Router()
import * as authController from '../controllers/authControllers.js'

router.post('/Register',authController.Register)

router.route('/login')
            .post(authController.login)

router.route('/forgot-password')
.post(authController.forgotPassword);

router.route('/verify-otp')
.post(authController.verifyOTP);

router.route('/reset-password')
.post(authController.resetPassword);


export default router