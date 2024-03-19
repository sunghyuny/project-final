# urls.py

from django.urls import path
from .views import *

app_name = 'hotel'
urlpatterns = [
    path('hotelcreate/', accommodation_create_direct, name='hotelcreate')
    # ...
]
