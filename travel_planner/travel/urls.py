from django.urls import path

from .views import *

urlpatterns = [
    path('', package, name='package'),
    path('create_package/', create_package,name='create_package'),
    path('booking_package/', book_package, name='booking_package'),
]