from django.urls import path
from .views import *
urlpatterns = [
    path('', post_list, name='list'),
    path('create/', post_new, name='create'),
    path('post/<int:pk>/', post_detail, name='post_detail'),
]