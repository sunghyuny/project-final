# urls.py

from django.urls import path
from .views import *
urlpatterns = [
path('activity/create/', create_activity, name='create_activity'),
]
