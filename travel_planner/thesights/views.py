from django.shortcuts import render, redirect, get_object_or_404
from .models import TouristSpot, RegionCategory


def main_sight(request):
    try:
        touristspot = TouristSpot.objects.get(id=10)  # ID가 10인 객체를 불러옴
    except TouristSpot.DoesNotExist:
        touristspot = TouristSpot.objects.get(id=1)  # ID가 10인 객체가 없을 경우 ID가 1인 객체를 불러옴

    return render(request, 'Sightseeing/sight.html', {'touristspot': touristspot})
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

        # 관광지 생성 및 지역 카테고리의 수량 증가
        tourist_spot = TouristSpot.objects.create(
            name=name, description=description, location=location,
            region_category=region_category, image=image
        )

        # 해당 지역 카테고리의 관광지 수량 증가
        region_category.quantity_tourist_spot += 1
        region_category.save()

        return redirect('/')  # 적절한 리다이렉트 URL로 변경하세요

    # GET 요청인 경우 모든 카테고리를 가져와서 템플릿에 전달
    region_categories = RegionCategory.objects.all()
    return render(request, 'spots/create.html', {'region_categories': region_categories})


def detail_sight(request, id):
    touristspot = get_object_or_404(TouristSpot, id=id)
    return render(request, 'detail/sight_detail.html', {'touristspot': touristspot})