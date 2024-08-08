# urls.py

from django.urls import path
from .views import *
urlpatterns = [
        path('', main_sight, name='main_sight'),
        path('spotsadd/', add_tourist_spot, name='create'),
        path('spots/<int:id>/', detail_sight, name='detail')

]

