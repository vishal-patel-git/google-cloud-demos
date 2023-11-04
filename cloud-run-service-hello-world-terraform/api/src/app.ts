import express from 'express';
import cors from 'cors';
import helmet from 'helmet';

const app = express();

app.use(helmet());

app.use(cors());

app.get('/', (_req, res) => {
  return res.json({message: 'Hello, World!'});
});

export {app};
