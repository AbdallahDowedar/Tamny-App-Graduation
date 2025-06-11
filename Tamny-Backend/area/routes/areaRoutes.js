import * as AreaController from '../Controller/areaController.js';
import express from 'express';

const router = express.Router();

router.post('/addArea', AreaController.addAreaController);              // Add Area
router.get('/name/:name', AreaController.getAreaByNameController);          // Get by name
router.get('/:id', AreaController.getAreaByIdController);                   // Get by ID
router.delete('/:id', AreaController.deleteAreaController);                 // Delete by ID
router.get('/',AreaController.getAllArea)

export default router;
