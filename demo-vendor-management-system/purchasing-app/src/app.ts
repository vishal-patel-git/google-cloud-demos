import path from 'path';
import express from 'express';
import helmet from 'helmet';

const app = express();

app.use(helmet());

app.set('views', path.join(__dirname, 'views'));

app.set('view engine', 'pug');

app.get('/', (_req, res) => {
  return res.render('index', {title: 'Home'});
});

export {app};
