import mongoose from 'mongoose';

const locationSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        unique: true,
        uppercase: true 
    } 
});

export const Location = mongoose.model('Location', locationSchema);