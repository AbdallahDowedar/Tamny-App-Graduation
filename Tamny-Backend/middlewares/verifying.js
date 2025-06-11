import jwt from 'jsonwebtoken';
import User from '../user/userModel.js';

export const verifying = async(req, res, next) => {
    const Auth = req.headers['Authorization'] || req.headers['authorization'];

    if (!Auth) {
        return res.status(401).json({ message: 'Unauthorized: No token provided' });
    }

    const token = Auth.split(' ')[1]

    try {
        const decoded = jwt.verify(token, process.env.JWTSECRETKEY);
        const cuurentUser = await User.findById(decoded.id);
        if (!cuurentUser) {
            return res.status(401).json({ message: 'user not found' });
        }

        req.user = cuurentUser;
        next();
    } 
    catch (error) {
        return res.status(401).json({ message: 'Unauthorized: Invalid token' ,error: error.message});
    }
};

