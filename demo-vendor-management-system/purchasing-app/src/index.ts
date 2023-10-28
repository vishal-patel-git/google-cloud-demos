import {app} from './app';
import {logger} from './logger';
import {config} from './config';

app.listen(config.port, () => {
  logger.info(
    `Google Cloud Recipes - Demo - Vendor Management System - Purchasing App server listening on port ${config.port}...`
  );
});
