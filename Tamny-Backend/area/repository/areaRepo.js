import Area from '../model/areaModel.js';

const insertArea = async (data) => {
    const area = new Area(data);
    return await area.save();
};

const getAreaByNameFromDB = async (name) => {
    return await Area.findOne({ name });
};

const getAreaByIdFromDB = async (id) => {
    return await Area.findById(id);
};

const deleteAreaFromDB = async (id) => {
    return await Area.findByIdAndDelete(id);
};

const getAllAreas = () => {
    return Area.find();
};

export {
    insertArea,
    getAreaByNameFromDB,
    getAreaByIdFromDB,
    deleteAreaFromDB,
    getAllAreas
};
