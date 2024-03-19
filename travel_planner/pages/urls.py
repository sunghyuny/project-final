from django.urls import path

from .views import *

urlpatterns = [
    path('', mainpage, name='mainpage'),
    path('map/', map, name='maps')
]