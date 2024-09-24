from django.urls import path

from .views import *

urlpatterns = [
    path('', mainpage, name='mainpage'),
    path('Admin/main/', admin_main, name='admin_mine'),
    path('Admin/lodg/', admin_lodg, name='admin_lodg'),
    path('Admin/member/', admin_member, name='admin_member'),
    path('Admin/trip/', admin_trip, name='admin_trip'),
    path('Admin/active/', admin_active, name='admin_active'),
    path('Admin/match/', admin_match, name='admin_match'),

]