import express from 'express'
const router = express.Router();
import * as adminController from '../controller/admincontroller.js'

router.route('/approveDoctor/:doctorId')
            .patch(adminController.approveDoctor)

router.route('/rejectDoctor/:doctorId')
            .delete(adminController.rejectDoctor)

router.route('/deleteDoctor/:doctorId')
            .delete(adminController.deleteDoctor)

router.route('/doctorCv/:doctorId')
            .get(adminController.getDoctorCV)

router.route('/')
            .get(adminController.getAllDoctors)


export default router    