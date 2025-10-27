from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APITestCase
from rest_framework import status


class APITestCase(APITestCase):
    """Test cases for API endpoints."""
    
    def test_api_root(self):
        """Test API root endpoint."""
        url = reverse('api_root')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('message', response.data)
        self.assertIn('endpoints', response.data)
    
    def test_api_app1_root(self):
        """Test API app1 root endpoint."""
        url = reverse('api_root')  # This will be the main API root
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
    
    def test_home_endpoint(self):
        """Test home endpoint."""
        url = '/api/app1/home'
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['healthy'], True)


class BasicTestCase(TestCase):
    """Basic test cases."""
    
    def test_basic_math(self):
        """Test basic math operations."""
        self.assertEqual(2 + 2, 4)
        self.assertNotEqual(2 + 2, 5)
    
    def test_string_operations(self):
        """Test string operations."""
        test_string = "Hello, World!"
        self.assertIn("Hello", test_string)
        self.assertEqual(len(test_string), 13)
