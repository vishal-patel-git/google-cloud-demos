import knex, {Knex} from 'knex';
const knexStringcase = require('knex-stringcase');
import {config} from '../config';

const knexConfig: Knex.Config = {
  client: 'pg',
  connection: {
    host: config.db.host,
    port: config.db.port,
    database: config.db.database,
    user: config.db.username,
    password: config.db.password,
  },
};

const options = knexStringcase(knexConfig);

const db = knex(options);

export {db};
