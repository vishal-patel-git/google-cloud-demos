import dotenv from 'dotenv';
import dotenvExpand from 'dotenv-expand';

const env = dotenv.config();
dotenvExpand.expand(env);

import type {Knex} from 'knex';
import {config as appConfig} from './src/config';

const config: Knex.Config = {
  client: 'pg',
  connection: {
    host: appConfig.db.host,
    port: appConfig.db.port,
    database: appConfig.db.database,
    user: appConfig.db.username,
    password: appConfig.db.password,
  },
};

module.exports = config;
