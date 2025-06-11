import * as LocationRepo from '../repository/locationRepo.js';


export const createLocation = async (data) => {
    const existing = await LocationRepo.getLocationByNameFromDB(data.name);
    if (existing) {
        throw new Error('Location already exists');
    }
    return await LocationRepo.insertLocation(data);
};

export const getLocationByName = async (name) => {
    return await LocationRepo.getLocationByNameFromDB(name);
};

export const getLocationById = async (id) => {
    return await LocationRepo.getLocationByIdFromDB(id);
};

export const removeLocationById = async (id) => {
    return await LocationRepo.deleteLocationFromDB(id);
};

export const getAllLocations = async() => {
    const getAllLocations = LocationRepo.getAllLocations()
    return await getAllLocations
}
