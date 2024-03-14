const { getPredictions } = require('../src/controllers/predictionsController');
const httpMocks = require('node-mocks-http');

jest.mock('axios');

describe('getPredictions', () => {
  it('should return 400 if no file is uploaded', async () => {
    const req = httpMocks.createRequest({
      method: 'POST',
      url: '/predict',
      file: null,
    });
    const res = httpMocks.createResponse();
    await getPredictions(req, res);
    expect(res.statusCode).toBe(400);
    expect(res._getData()).toBe('No file uploaded.');
  });
});
