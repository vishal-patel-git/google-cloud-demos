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

    router.get('/add', async (req, res, next) => {
      try {
        return res.render('vendors/add', {title: 'Add Vendor'});
      } catch (err) {
        return next(err);
      }
    });

    router.post('/add', async (req, res, next) => {
      try {
        const {name, address} = req.body;

        await this.options.vendorsClient.createVendor(name, address);

        return res.redirect('/vendors');
      } catch (err) {
        return next(err);
      }
    });

    return router;
  }
}

export {VendorsRouter};
