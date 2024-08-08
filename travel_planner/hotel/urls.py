# urls.py

from django.urls import path
from .views import *

app_name = 'hotel'
urlpatterns = [
    path('hotelcreate/', accommodation_create, name='hotelcreate'),
    path('detail/<int:hotel_id>/', hotel_detail, name='detail'),
    path('', mainhotel, name='hotel_main')
    # ...
]


