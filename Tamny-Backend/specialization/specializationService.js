import * as specializationRepo from './specializationRepo.js';


const addSpecialization = async (name) => {
    const exists = await specializationRepo.findByName(name);
    if (exists) {
        throw new Error("Specialization already exists");
    }
    return await specializationRepo.createSpecialization(name);
};

const getAllspecializations = async() => {
    const specializations = specializationRepo.getAllSpecialization()
    return await specializations
}

export  {
    addSpecialization,
    getAllspecializations
};
