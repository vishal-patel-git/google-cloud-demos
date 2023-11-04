import {Router} from 'express';
import {Joi, Segments, celebrate} from 'celebrate';
import {StatusCodes} from 'http-status-codes';
import {VendorsService} from '../../services';

interface VendorsRouterOptions {
  vendorsService: VendorsService;
}

class VendorsRouter {
  constructor(private readonly options: VendorsRouterOptions) {}

  get router() {
    const router = Router();

    router.post(
      '/',
      celebrate({
        [Segments.BODY]: Joi.object().keys({
          name: Joi.string().required(),
          address: Joi.string().required(),
        }),
      }),
      async (req, res, next) => {
        try {
          const {name, address} = req.body;

          const vendor = await this.options.vendorsService.createVendor(
            name,
            address
          );

          return res.status(StatusCodes.CREATED).json(vendor);
        } catch (err) {
          return next(err);
        }
      }
    );

    router.get('/:vendorId', async (req, res, next) => {
      try {
        const {vendorId} = req.params;

        const vendor = await this.options.vendorsService.getVendor(vendorId);

        return res.json(vendor);
      } catch (err) {
        return next(err);
      }
    });

    router.delete('/:vendorId', async (req, res, next) => {
      try {
        const {vendorId} = req.params;

        await this.options.vendorsService.deleteVendor(vendorId);

        return res.status(StatusCodes.NO_CONTENT).json({});
      } catch (err) {
        return next(err);
      }
    });

    return router;
  }
}

export {VendorsRouter};
