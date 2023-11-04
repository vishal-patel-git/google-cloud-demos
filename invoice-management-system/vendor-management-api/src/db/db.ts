import knex, {Knex} from 'knex';
const knexStringcase = require('knex-stringcase');
import {config} from '../config';

const knexConfig: Knex.Config = {
  client: 'pg',
  connection: {
    host: config.pg.host,
    port: config.pg.port,
    database: config.pg.name,
    user: config.pg.username,
    password: config.pg.password,
  },
};

const options = knexStringcase(knexConfig);

const db = knex(options);

export {db};
