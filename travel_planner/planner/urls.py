# urls.py

from django.urls import path
from .views import *

urlpatterns = [
path('activity/create/', create_activity, name='create_activity'),
path('', trip_plan_form, name='planer_create'),
    path('plan1/',location, name='location'),
    path('plan2/',plan2, name='lodging'),
    path('plan3/', plan3, name='Activity'),
    path('plan4/', plan4, name='summary')

]
