from django.urls import path, include
from .views import *
from django.contrib.auth import views as auth_views
app_name = 'api'

urlpatterns = [
    path('', homepage_view, name='homepage'),
    path('csrf_token/', get_csrf_token, name='csrf_token'),
    path('flutter_signup/', flutter_signup, name='flutter_signup'),
    path('flutter_login/', flutter_login, name='flutter_login'),
    path('get_user_info/', get_user_info, name='get_user_info'),
    path('flutter_logout/', flutter_logout, name='flutter_logout'),
    path('accommodation/', accommodations_view, name='api_accommodation'),
    path('flutter_plan1/', trip_plan_form, name='flutter_create'),
    path('flutter_plan2/', location, name='flutter_location'),
    path('flutter_plan3/', plan2, name='flutter_accommodation'),
    path('activity/', activity_view, name='fluter_activity'),# 활동 선택
    path('flutter_plan5/<int:trip_plan_id>/', plan4, name='flutter_summary'),
    path('fluter_mypage/', user_info, name='mypage'),
]              # URL 경로 수정