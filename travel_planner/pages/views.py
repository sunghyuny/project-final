

from django.shortcuts import render
from thesights.models import RegionCategory
# Create your views here.


def mainpage(request):
    region_categories = RegionCategory.objects.all()
    return render(request, 'pages/home.html',{'region_categories': region_categories})