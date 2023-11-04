import express from 'express';
import * as lb from '@google-cloud/logging-bunyan';
import cors from 'cors';
import helmet from 'helmet';
import {errorHandler} from './error-handler';
import {config} from './config';

async function createApp() {
  const app = express();

  const {logger, mw} = await lb.express.middleware({
    level: config.logLevel,
  });

  app.use(mw);

  app.use(helmet());

  app.use(cors());

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

  return {app, logger};
}

export {createApp};
