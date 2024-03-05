# urls.py

from django.urls import path
from .views import *
urlpatterns = [
    path('spotsadd/', add_tourist_spot, name='create'),

]

