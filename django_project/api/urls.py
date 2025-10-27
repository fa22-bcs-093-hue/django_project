from django.urls import include, path
from rest_framework.decorators import api_view
from rest_framework.response import Response

from api.app1 import urls as app1_urls


@api_view(['GET'])
def api_root(request):
    """API root endpoint."""
    return Response({
        'message': 'Django REST Framework API',
        'version': '1.0',
        'endpoints': {
            'app1': '/api/app1/',
            'app1_home': '/api/app1/home'
        }
    })


urlpatterns = [
    path('', api_root, name='api_root'),
    path(r'app1/', include(app1_urls))
]
