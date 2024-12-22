from django.urls import path

from .views import *

urlpatterns = [
    path('', mainpage, name='mainpage'),
    path('', flutter_mainpage, name='flutter_main'),
    path('Admin/main/', admin_main, name='admin_mine'),  # admin_main 뷰 연결
    path('Admin/lodg/', admin_lodg, name='admin_lodg'),
    path('Admin/member/', admin_member, name='admin_member'),
    path('Admin/trip/', admin_trip, name='admin_trip'),
    path('Admin/active/', admin_active, name='admin_active'),
    path('Admin/match/', admin_match, name='admin_match'),
    path('Admin/post/', admin_post, name='admin_post'),
]
