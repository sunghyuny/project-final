# views.py
from django.contrib.sites import requests
from django.http import HttpResponse,HttpRequest
from django.shortcuts import render, redirect
from .models import *
from hotel.models import *


def planner(request):
    return render(request, 'Planner/schedule.html')
def create_activity(request):
    if request.method == 'POST':
        new_activity = activity()
        new_activity.name = request.POST.get('name')
        new_activity.price = request.POST.get('price')
        new_activity.photo = request.FILES.get('photo')
        new_activity.location = request.POST.get('location')
        new_activity.telephone = request.POST.get('telephone')
        new_activity.time = request.POST.get('time')

        # 카테고리 처리
        category_name = request.POST.get('category')
        category, created = activity_category.objects.get_or_create(name=category_name)
        new_activity.category = category

        new_activity.save()
        return redirect('/')  # 성공 시 리디렉트될 URL을 설정하세요.

    return render(request, 'pages/activity_create.html')


def trip_plan_form(request):
    if request.method == 'POST':
        arrival_date = request.POST.get('arrival_date')
        adults = int(request.POST.get('adults'))
        teens = int(request.POST.get('teens'))
        children = int(request.POST.get('children'))

        total_people = adults + teens + children

        trip_plan = TripPlan.objects.create(arrival_date=arrival_date, total_people=total_people)
        trip_plan.save()
        return redirect('/planner/plan1/')


    return render(request, 'Planner/schedule.html')


def location(request):
    if request.method == 'POST':
        latitude = request.POST.get('latitude')
        longitude = request.POST.get('longitude')

        # 네이버 지도 API 호출하여 좌표를 지역 이름으로 변환
        naver_api_url = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords={longitude},{latitude}&orders=addr&output=json"
        headers = {
            "X-NCP-APIGW-API-KEY-ID": "8rmgkdfw2q",
            "X-NCP-APIGW-API-KEY": "7C5A0ZwU9zwbjb9vn5vRnB3fgBmv1rvOhuXi8F5L"
        }
        response = requests.get(naver_api_url, headers=headers)
        if response.status_code == 200:
            data = response.json()
            # API에서 얻은 지역 이름을 저장하거나 처리할 수 있음
            region_name = data['results'][0]['region']['area1']['name']
            # 이후 데이터베이스에 저장하거나 다음 작업을 수행할 수 있음
            return render(request, 'Planner/lodging.html', {'region_name': region_name})
        else:
            # API 호출 실패 시 처리할 내용
            pass
    else:
        return render(request, 'Planner/location.html')



def plan2(request):
    if request.method == 'POST':
        selected_accommodation_id = request.POST.get('accommodation_id')

        # 쿠키에 선택한 숙소의 고유 식별자(ID)를 저장합니다.
        response = HttpResponse()
        response.set_cookie('selected_accommodation_id', selected_accommodation_id)

        # 사용자에게 알림을 표시하거나 다음 단계로 이동할 수 있습니다.
        return HttpResponse("숙소가 선택되었습니다. ID: " + selected_accommodation_id)
        # 다음 단계로 이동하는 코드를 여기에 추가할 수 있습니다.

    # 숙소 목록을 가져와서 템플릿에 전달합니다.
    accommodations = Accommodation.objects.all()
    return render(request, 'Planner/lodging.html', {'accommodations': accommodations})
def plan3(request):
    return render(request, 'Planner/activity.html')

def plan4(request):
    return render(request, 'Planner/summary.html')
