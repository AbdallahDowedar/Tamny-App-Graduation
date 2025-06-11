import * as rateService from '../service/rateService.js'
import catchAsync from '../../utils/CatchAsync.js'

export const addRate = catchAsync(    async (req, res) => {
        const rate = req.params.rate;
        const doctorId = req.params.doctorId;

        if (!rate || isNaN(Number(rate)) || Number(rate) < 1 || Number(rate) > 5) {
            return res.status(400).json({
                status: 'fail',
                message: 'يجب أن يكون التقييم رقماً بين 1 و 5'
            });
        }

        const rateValue = Number(rate);
        const result = await rateService.addReview(req.user.id, doctorId, rateValue);
        res.status(201).json(result);
    }
)

