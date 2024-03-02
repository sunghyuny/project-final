# urls.py

from django.urls import path
from .views import create_tourist_spot,get_csrf_token
urlpatterns = [
    path('tourist/', create_tourist_spot, name='tourist'),
    path('csrf/', get_csrf_token, name='csrf')
]

