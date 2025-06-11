import * as rateRepo from '../repo/rateRepo.js'

export const addReview = async (userId, doctorId,rate) => {
  const data = await rateRepo.createrate(userId, doctorId, rate);
  return {
    success: true,
    msg: 'rate added and product updated',
    data
  };
};
