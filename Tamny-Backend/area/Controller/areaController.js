import { createArea, getAreaByName, getAreaById, removeAreaById, getAllAreas } from '../services/areaService.js';
import catchAsync from '../../utils/CatchAsync.js';

export const addAreaController = async (req, res) => {
    try {
        const Area = await createArea(req.body);
        res.status(201).json(Area);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

export const getAreaByNameController = async (req, res) => {
    try {
        const Area = await getAreaByName(req.params.name);
        if (!Area) return res.status(404).json({ message: 'Area not found' });
        res.json(Area);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

export const getAreaByIdController = async (req, res) => {
    try {
        const Area = await getAreaById(req.params.id);
        if (!Area) return res.status(404).json({ message: 'Area not found' });
        res.json(Area);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

export const deleteAreaController = async (req, res) => {
    try {
        const result = await removeAreaById(req.params.id);
        if (!result) return res.status(404).json({ message: 'Area not found' });
        res.json({ message: 'Area deleted successfully' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

export const getAllArea = catchAsync(async(req,res,next) => {
    const Areas = await getAllAreas()
    res.json({
    status : "success",
    result : Areas.length,
    data : Areas
    });       
})
