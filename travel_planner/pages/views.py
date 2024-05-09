

from django.shortcuts import render
from thesights.models import *
# Create your views here.


def mainpage(request):
    region_categories = RegionCategory.objects.all()
    tourist_spots = TouristSpot.objects.all()
    return render(request, 'pages/home.html', {'region_categories': region_categories, 'tourist_spots': tourist_spots})