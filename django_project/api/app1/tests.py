from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APITestCase
from rest_framework import status


class App1TestCase(APITestCase):
    """Test cases for App1 endpoints."""
    
    def test_app1_root(self):
        """Test app1 root endpoint."""
        url = '/api/app1/'
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('message', response.data)
        self.assertIn('endpoints', response.data)
    
    def test_home_view(self):
        """Test home view endpoint."""
        url = '/api/app1/home'
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['healthy'], True)
    
    def test_home_view_methods(self):
        """Test home view only accepts GET method."""
        url = '/api/app1/home'
        
        # Test GET method (should work)
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        
        # Test POST method (should not work)
        response = self.client.post(url)
        self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)


class App1BasicTestCase(TestCase):
    """Basic test cases for App1."""
    
    def test_app1_imports(self):
        """Test that app1 modules can be imported."""
        try:
            from api.app1 import views
            from api.app1 import urls
            from api.app1 import models
            self.assertTrue(True)
        except ImportError as e:
            self.fail(f"Failed to import app1 modules: {e}")
    
    def test_app1_views_exist(self):
        """Test that app1 views exist."""
        from api.app1.views import home_view
        self.assertTrue(callable(home_view))