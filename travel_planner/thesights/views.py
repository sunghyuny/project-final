from django.shortcuts import render, redirect
from .models import TouristSpot, RegionCategory


def main_sight(request):
    return render(request, 'Sightseeing/sight.html')
def add_tourist_spot(request):
    if request.method == 'POST':
        name = request.POST.get('name')
        description = request.POST.get('description')
        location = request.POST.get('location')
        region_category_name = request.POST.get('region_category')  # 이름을 가져옴
        # 요청된 지역 카테고리가 이미 존재하는지 확인
        try:
            region_category = RegionCategory.objects.get(name=region_category_name)  # 이름으로 가져옴
        except RegionCategory.DoesNotExist:
            # 존재하지 않으면 새로운 카테고리 생성
            region_category = RegionCategory.objects.create(name=region_category_name)

        image = request.FILES.get('image')
        tourist_spot = TouristSpot.objects.create(name=name, description=description, location=location,
                                                  region_category=region_category, image=image)
        return redirect('/')  # 적절한 리다이렉트 URL로 변경하세요

    # GET 요청인 경우 모든 카테고리를 가져와서 템플릿에 전달
    region_categories = RegionCategory.objects.all()
    return render(request, 'spots/create.html', {'region_categories': region_categories})
