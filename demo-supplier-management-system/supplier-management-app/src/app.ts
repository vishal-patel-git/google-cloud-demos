import path from 'path';
import express from 'express';
import helmet from 'helmet';
import {db} from './db';
import {SuppliersService} from './suppliers';

const app = express();

const suppliersService = new SuppliersService({db});

app.use(helmet());

app.set('views', path.join(__dirname, 'views'));

app.set('view engine', 'pug');

app.get('/', async (_req, res) => {
  const suppliers = await suppliersService.listSuppliers();

  return res.render('pages/index', {title: 'Home', suppliers});
});

export {app};
