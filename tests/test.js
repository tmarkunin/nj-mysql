var request = require('supertest');

var app = require('../app').app;

describe('GET /healthz', function() {
  it('health check returns valid answer', function(done) {
    request(app)
      .get('/healthz')
      .expect(200, done);
      .end(function (err) {
                if(err) {
                    return done(err);
                }
                return done();
            })
  });
});
