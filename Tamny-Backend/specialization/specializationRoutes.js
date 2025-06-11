import express from 'express';
const router = express.Router();
import * as specialization_Controller from './specializationController.js';
router.route('/add_specializations')
  .post(specialization_Controller.createSpecialization);

router.route('/')
  .get(specialization_Controller.getAllSpecializations);

  export default router;
