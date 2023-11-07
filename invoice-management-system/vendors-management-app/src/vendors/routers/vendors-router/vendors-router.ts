import {Router} from 'express';
import {VendorsClient} from '../../../common/clients';

interface VendorsRouterOptions {
  vendorsClient: VendorsClient;
}

class VendorsRouter {
  constructor(private readonly options: VendorsRouterOptions) {}

  get router() {
    const router = Router();

    router.get('/', async (req, res, next) => {
      try {
        const vendors = await this.options.vendorsClient.listVendors({
          orderBy: [
            {
              field: 'name',
              direction: 'asc',
            },
          ],
        });

        return res.render('vendors', {title: 'Vendors list', vendors});
      } catch (err) {
        return next(err);
      }
    });

    return router;
  }
}

export {VendorsRouter};
