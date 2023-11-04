import {app} from './app';
import {logger} from './logger';
import {config} from './config';

app.listen(config.port, () => {
  logger.info(
    `Google Cloud Demos - Invoice Management System - Vendor Management API server listening on port ${config.port}...`
  );
});
