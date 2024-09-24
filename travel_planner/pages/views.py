

from django.shortcuts import render
from thesights.models import *
# Create your views here.


def mainpage(request):
    region_categories = RegionCategory.objects.all()
    tourist_spots = TouristSpot.objects.all()
    return render(request, 'pages/home.html', {'region_categories': region_categories, 'tourist_spots': tourist_spots})

def admin_main(request):
    return render(request, 'Admin/Manage_main.html')

def admin_lodg(request):
    return render(request, 'Admin/Lodg_manage.html')

def admin_member(request):
    return render(request, 'Admin/member_manage.html')

def admin_trip(request):
    return render(request, 'Admin/Trip_manage.html')

def admin_active(request):
    return render(request, 'Admin/Active_manage.html')

def admin_match(request):
    return render(request, 'Admin/Match_manage.html')