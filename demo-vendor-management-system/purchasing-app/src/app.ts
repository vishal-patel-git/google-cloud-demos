import path from 'path';
import express from 'express';
import helmet from 'helmet';
import {db} from './db';
import {VendorsService} from './vendors';

const app = express();

const vendorsService = new VendorsService({db});

app.use(helmet());

app.set('views', path.join(__dirname, 'views'));

app.set('view engine', 'pug');

app.get('/', (_req, res) => {
  return res.render('pages/index', {title: 'Home'});
});

app.get('/vendors', async (_req, res) => {
  const vendors = await vendorsService.listVendors();

  return res.render('pages/vendors/index', {title: 'Vendors', vendors});
});

export {app};
