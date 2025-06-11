import * as AreaRepo from '../repository/areaRepo.js';


export const createArea = async (data) => {
    const existing = await AreaRepo.getAreaByNameFromDB(data.name);
    if (existing) {
        throw new Error('Area already exists');
    }
    return await AreaRepo.insertArea(data);
};

export const getAreaByName = async (name) => {
    return await AreaRepo.getAreaByNameFromDB(name);
};

export const getAreaById = async (id) => {
    return await AreaRepo.getAreaByIdFromDB(id);
};

export const removeAreaById = async (id) => {
    return await AreaRepo.deleteAreaFromDB(id);
};

export const getAllAreas = async() => {
    const getAllAreas = AreaRepo.getAllAreas()
    return await getAllAreas
}
