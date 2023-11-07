import {createApp} from './app';
import {config} from './config';

createApp().then(({app, logger}) => {
  const server = app.listen(config.port, () => {
    logger.info(
      `Google Cloud Demos - Invoice Management System - Vendors Service server listening on port ${config.port}...`
    );
  });

  async function shutdown() {
    logger.info(
      'Google Cloud Demos - Invoice Management System - Vendors Service server shutting down...'
    );
    server.close(() => {
      logger.info(
        'Google Cloud Demos - Invoice Management System - Vendors Service server closed'
      );
    });
  }

  process.on('SIGTERM', shutdown);
  process.on('SIGINT', shutdown);
});
