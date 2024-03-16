from app import app
import pytest
from flask_testing import TestCase

class TestPredictions(TestCase):
    def create_app(self):
        app.config['TESTING'] = True
        return app

    def test_predict_no_file(self):
        response = self.client.post('/predict')
        self.assertEqual(response.status_code, 400)
        self.assertIn(b'No file provided', response.data)
