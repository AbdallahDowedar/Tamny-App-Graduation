
import * as Location_Controller from '../Controller/locationController.js';
import express from 'express';

const router = express.Router();

router.post('/addlocation', Location_Controller.addLocationController);              // Add location
router.get('/name/:name', Location_Controller.getLocationByNameController);          // Get by name
router.get('/:id', Location_Controller.getLocationByIdController);                   // Get by ID
router.delete('/:id', Location_Controller.deleteLocationController);                 // Delete by ID
router.get('/',Location_Controller.getAllLocation)

export default router;
