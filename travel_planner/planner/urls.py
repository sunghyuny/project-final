# urls.py

from django.urls import path
from .views import TravelPlanAPIView

urlpatterns = [
    path('api/TravelPlan/', TravelPlanAPIView.as_view(), name='Travel-Plan-api'),
    # ...
]
