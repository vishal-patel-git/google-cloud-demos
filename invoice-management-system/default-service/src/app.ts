import express from 'express';
import * as lb from '@google-cloud/logging-bunyan';
import cors from 'cors';
import helmet from 'helmet';
import {StatusCodes} from 'http-status-codes';
import {config} from './config';

async function createApp() {
  const app = express();

  const {logger, mw} = await lb.express.middleware({
    level: config.logLevel,
  });

  app.use(mw);

  app.use(helmet());

  app.use(cors());

  app.use('/', (req, res) => {
    res.sendStatus(StatusCodes.OK);
  });

  return {app, logger};
}

export {createApp};
