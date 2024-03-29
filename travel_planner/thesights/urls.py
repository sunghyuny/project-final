# urls.py
from django.template.context_processors import static
from django.urls import path
from .views import *
from travel_planner import settings


urlpatterns = [
    path('', spotmain, name='spotmain'),
    path('spotsadd/', add_tourist_spot, name='create'),
    path('detail/<int:spot_id>/',detail, name='detail')

]

