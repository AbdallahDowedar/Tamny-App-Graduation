import user from '../../user/userModel.js'
import Doctor from '../../doctor/model/doctorModel.js'

export const FindByEmail = async(email) => {
    const userDoc = await user.findOne({ email }).lean();
    console.log('User found:', userDoc);

    if (userDoc && userDoc.role === 'doctor') {
        const doctorDoc = await Doctor.findOne({ user: userDoc._id }).lean();
        console.log('Doctor found:', doctorDoc);

        if (doctorDoc) {
            return {
                ...userDoc,
                doctorId: doctorDoc._id,
                isVerified: doctorDoc.isVerified || false
            };
        }
    }

    return userDoc;
}



export const saveUser = async (userData) => {
    if (userData._id) {
        // If user has _id, it's an update
        return await user.findByIdAndUpdate(
            userData._id,
            { $set: userData },
            { new: true }
        );
    } else {
        // If no _id, it's a new user
        const newUser = new user(userData);
        return await newUser.save();
    }
};


export const updateById = async (userId, updateData) => {
  return await user.findByIdAndUpdate(userId, updateData, { new: true });
};
