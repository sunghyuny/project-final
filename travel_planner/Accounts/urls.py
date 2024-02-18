"""
URL configuration for travel_planner project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""# your_app_name/urls.py

from django.urls import path
from .views import SignupView,get_csrf_token,LoginApi

urlpatterns = [
    path('signup/', SignupView.as_view(), name='signup'),
    path('csrf/', get_csrf_token, name='get-csrf-token'),
    path('login/', LoginApi.as_view(), name='login'),
    path('loginstaus/', LoginApi.as_view(), name='staus'),
    # 다른 URL 패턴들을 추가할 수 있습니다.
]




