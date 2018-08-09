from copy import deepcopy
import unittest
import json
import os

from app import app, db

basedir = os.path.abspath(os.path.dirname(__file__))

class TestFlaskApi(unittest.TestCase):

    def setUp(self):
        app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + \
            os.path.join(basedir, 'test.db')
        self.app = app.test_client()
        db.drop_all()
        db.create_all()

    def test_get_all(self):
        response = self.app.get('/users', follow_redirects=True)
        self.assertEqual(response.status_code, 200)

    def test_post_valid_user(self):
        user={"username": "test1", "email": "test1@test.com"}
        response = self.app.post('/user',
                                    follow_redirects=True,
                                    data=json.dumps(user),
                                    content_type='application/json')
        self.assertEqual(response.status_code, 200)

    def test_post_invalid_user_without_email(self):
        user={"username": "test1"}
        response = self.app.post('/user',
                                    data=json.dumps(user),
                                    content_type='application/json')
        self.assertEqual(response.status_code, 500)

    def test_get_user(self):
        user={"username": "test_get", "email": "test1@test.com"}
        response = self.app.post('/user',
                                    data=json.dumps(user),
                                    content_type='application/json')
        response = self.app.get('/user/1')
        data = json.loads(response.get_data())
        self.assertEqual(data['id'], 1)
        self.assertEqual(data['username'], "test_get")
        self.assertEqual(response.status_code, 200)

    def test_remove_user(self):
        user={"username": "test1", "email": "test1@test.com"}
        response = self.app.post('/user',
                                    data=json.dumps(user),
                                    content_type='application/json')
        response = self.app.delete('/user/1', follow_redirects=True)
        data = json.loads(response.get_data())
        self.assertEqual(data['id'], 1)
        self.assertEqual(data['username'], "test1")
        self.assertEqual(response.status_code, 200)

if __name__ == "__main__":
    unittest.main()
