import mongoose from 'mongoose';

const areaSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        unique: true,
        uppercase: true 
    } 
});

const Area = mongoose.model('Area', areaSchema);
export default Area;