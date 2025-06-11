import * as specializationService from './specializationService.js';
import CatchAsync from '../utils/CatchAsync.js';
const createSpecialization = async (req, res) => {
    try {
        const { name } = req.body;
        const result = await specializationService.addSpecialization(name);
        res.status(201).json({ message: "Specialization created", data: result });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

const getAllSpecializations = CatchAsync(async(req,res,next) => {
    const Specializations = await specializationService.getAllspecializations()
    res.json({
    status : "success",
    result : Specializations.length,
    data : Specializations
    });       
})

export {
    createSpecialization,
    getAllSpecializations
};
