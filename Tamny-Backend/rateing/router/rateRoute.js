import express from 'express'
const router = express.Router();
import {addRate} from '../controller/rateController.js'
import {verifying} from '../../middlewares/verifying.js'

router.route('/:doctorId/:rate')
    .post(verifying,addRate)

export default router
