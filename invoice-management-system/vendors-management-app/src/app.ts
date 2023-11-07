import path from 'path';
import express from 'express';
import * as lb from '@google-cloud/logging-bunyan';
import {StatusCodes} from 'http-status-codes';
import {VendorsClient} from './common/clients';
import {VendorsRouter} from './vendors';
import {config} from './config';

async function createApp() {
  const vendorsClient = new VendorsClient({
    baseUrl: config.vendorsService.baseUrl,
  });

  const vendorsRouter = new VendorsRouter({vendorsClient}).router;

  const app = express();

  const {logger, mw} = await lb.express.middleware({
    level: config.logLevel,
    redirectToStdout: true,
    skipParentEntryForCloudRun: true,
  });

  app.set('views', path.join(__dirname, 'views', 'pages'));
  app.set('view engine', 'pug');

  app.use(mw);

  app.use(express.urlencoded({extended: true}));

  app.all('/', (req, res) => {
    return res.redirect(StatusCodes.MOVED_PERMANENTLY, '/vendors');
  });

  app.use('/vendors', vendorsRouter);

  return {app, logger};
}

export {createApp};
