import express from 'express';
import doctorController from '../controller/doctorController.js'
import upload from '../../utils/uploadMiddleware.js';

const router = express.Router();

router.route('/register_doctor')
  .post(doctorController.registerDoctorController);

router.route('/login_doctor')
  .post(doctorController.loginDoctorController);
router.route('/upload-cv')
  .post(upload.single('cv'), doctorController.uploadDoctorCVController);

router.route('/filter')
  .get(doctorController.FilterDoctors);

router.route('/update_doctor_profile/:id')
  .patch(doctorController.updateDoctorProfileController);

router.route('/upload-cv/:id')
  .patch(upload.single('cvPath'), doctorController.uploadDoctorCVController);

// Route for searching by name only
router.route('/search')
  .get(doctorController.searchDoctorsName);

router.route('/area')
  .get(doctorController.searchDoctorsArea);

// Route for advanced search with multiple filters
router.route('/search/advanced')
  .get(doctorController.searchDoctors);

router.route('/:id')
  .get(doctorController.getDoctor);

router.route('/filter/:price')
  .get(doctorController.priceFilter);


export default router;
