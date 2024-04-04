# urls.py

from django.urls import path
from .views import TravelPlanAPIView

urlpatterns = [
<<<<<<< HEAD
path('activity/create/', create_activity, name='create_activity'),
path('', trip_plan_form, name='planer_create'),
    path('plan1/',plan1, name='location'),
    path('plan2/',plan2, name='lodging'),
    path('plan3/', plan3, name='Activity'),
    path('plan4/', plan4, name='summary')


=======
    path('api/TravelPlan/', TravelPlanAPIView.as_view(), name='Travel-Plan-api'),
    # ...
>>>>>>> ec977d2970c67426f268debd3dc5fb437ded3e24
]
