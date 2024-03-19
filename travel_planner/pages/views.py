

from django.shortcuts import render
from thesights.models import TouristSpot
# Create your views here.


def mainpage(request):
    tourist_spots = TouristSpot.objects.all()
    return render(request, 'pages/home.html', {'tourist_spots': tourist_spots})

def map(request):
    return render(request, 'map.html')