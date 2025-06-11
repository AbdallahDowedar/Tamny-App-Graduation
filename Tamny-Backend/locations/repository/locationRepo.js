import { Location } from '../model/locationModel.js';

 const insertLocation = async (data) => {
    const location = new Location(data);
    return await location.save();
};

 const getLocationByNameFromDB = async (name) => {
    return await Location.findOne({ name });
};

 const getLocationByIdFromDB = async (id) => {
    return await Location.findById(id);
};

 const deleteLocationFromDB = async (id) => {
    return await Location.findByIdAndDelete(id);
};

const getAllLocations = () => {
    return Location.find()
}

export {
    insertLocation ,  getLocationByNameFromDB , getLocationByIdFromDB , deleteLocationFromDB,
    getAllLocations
}