from django.urls import include, path
from rest_framework.decorators import api_view
from rest_framework.response import Response

from api.app1.views import home_view


@api_view(['GET'])
def app1_root(request):
    """App1 root endpoint."""
    return Response({
        'message': 'App1 API Endpoints',
        'endpoints': {
            'home': '/api/app1/home'
        }
    })


urlpatterns = [
    path('', app1_root, name='app1_root'),
    path('home', home_view, name='home')
]
