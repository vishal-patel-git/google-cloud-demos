import express from 'express';
import * as lb from '@google-cloud/logging-bunyan';
import cors from 'cors';
import helmet from 'helmet';
import {Client as GoogleMapsClient} from '@googlemaps/google-maps-services-js';
import {connect} from './db';
import {HealthCheckRouter} from './health-check';
import {VendorsService, VendorsRouter} from './vendors';
import {errorHandler} from './error-handler';
import {config} from './config';

async function createApp() {
  const db = connect();

  await db.migrate.latest();

  const googleMapsClient = new GoogleMapsClient();

  const vendorsService = new VendorsService({
    db,
    googleMaps: {
      client: googleMapsClient,
      apiKey: config.googleMapsServices.apiKey,
    },
  });

  const healthCheckRouter = new HealthCheckRouter({db}).router;

  const vendorsRouter = new VendorsRouter({vendorsService}).router;

  const app = express();

  const {logger, mw} = await lb.express.middleware({
    level: config.logLevel,
    redirectToStdout: true,
    skipParentEntryForCloudRun: true,
  });

  app.use(mw);

  app.use(helmet());

  app.use(cors());

  app.use(express.json());

  app.use('/', healthCheckRouter);

  app.use('/vendors', vendorsRouter);

  app.use(
    async (
      err: Error,
      req: express.Request,
      res: express.Response,
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      _next: express.NextFunction
    ) => {
      await errorHandler.handleError(err, req, res);
    }
  );

  return {app, db, logger};
}

export {createApp};
