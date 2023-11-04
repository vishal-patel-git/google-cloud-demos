import request from 'supertest';
import {app} from '../../src/app';

describe('GET /', () => {
  it('should return a message', async () => {
    const response = await request(app)
      .get('/')
      .set('Accept', 'application/json');

    expect(response.status).toBe(200);
    expect(response.headers['content-type']).toBe(
      'application/json; charset=utf-8'
    );
    expect(response.body).toStrictEqual({message: 'Hello, World!'});
  });
});
