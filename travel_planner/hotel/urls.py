# urls.py

from django.urls import path
from .views import *

app_name = 'hotel'
urlpatterns = [
    path('hotelcreate/', accommodation_create, name='hotelcreate'),
    path('detail/<int:hotel_id>/', hotel_detail, name='detail'),
    path('', mainhotel, name='hotel_main'),
    path('reserve/<int:accommodation_id>/', reserve_accommodation, name='reserve'),
    path('reservation_success/<int:reservation_id>/', reservation_success, name='reservation_success'),
]
