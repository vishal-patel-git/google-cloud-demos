import {Router} from 'express';

class HealthCheckRouter {
  get router() {
    const router = Router();

    router.get('/', (req, res) => {
      return res.json({});
    });

    return router;
  }
}

export {HealthCheckRouter};
